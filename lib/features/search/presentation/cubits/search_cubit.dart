import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../../listing/data/models/browse_listing.dart';
import '../../../listing/data/models/browse_page.dart';
import '../../../listing/repository/listing_repository.dart';
import '../../../saved/repository/saved_listings_repository.dart';
import '../../data/models/search_filter_options.dart';
import '../../data/models/search_filters.dart';
import '../../data/search_filter_builder.dart';

part 'search_cubit.freezed.dart';

/// Search screen state (data-model §3.1, contract `search-browse.md`).
///
/// The list-rendering states are derived from the fields: `loaded` is true
/// after the first successful page fetch; `isLoading && !loaded` renders the
/// skeleton (FR-006); `loaded && items.isEmpty` renders the localized empty
/// state; a non-null [failure] renders the error + retry.
@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default(false) bool isLoadingOptions,
    SearchFilterOptions? options,
    Failure? optionsFailure,
    @Default(SearchFilters()) SearchFilters filters,
    @Default(<BrowseListing>[]) List<BrowseListing> items,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    @Default(false) bool loaded,
    Failure? failure,

    /// Set when an optimistic heart mutation fails (D8) — the screen surfaces
    /// it as a localized message and then calls [SearchCubit.clearTransientFailure].
    Failure? transientFailure,
  }) = _SearchState;
}

/// Drives the Search screen (contract `search-browse.md`, D7):
/// - loads the filter options once on first open (`fetchMeta` + `LocalityOptions`);
/// - loads the first page with a skeleton state;
/// - commits filters with a ~400 ms debounce and a generation guard that drops
///   stale responses (FR-004, SC-002);
/// - paginates (`loadMore`) with an in-flight flag and appends pages;
/// - toggles the saved heart optimistically through the shared
///   [SavedListingsRepository] (D8).
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required ListingRepository listingRepository,
    required SavedListingsRepository savedListingsRepository,
  })  : _listingRepository = listingRepository,
        _savedListingsRepository = savedListingsRepository,
        super(const SearchState());

  static const Duration _debounceDuration = Duration(milliseconds: 400);

  final ListingRepository _listingRepository;
  final SavedListingsRepository _savedListingsRepository;
  final SearchFilterBuilder _builder = const SearchFilterBuilder();

  Timer? _debounce;
  int _generation = 0;
  bool _loadingMore = false;

  /// D11: newest (`createdAt:desc`) may be rejected by the backend — after the
  /// first rejection the cubit retries without a sort and keeps this set so it
  /// never repeats the failed request.
  bool _sortFallbackApplied = false;

  /// Per-listing in-flight guard so a double tap fires exactly one mutation.
  final Set<String> _savingIds = <String>{};

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  /// Loads the filter option sources once: `GET /listings/meta` (categories +
  /// amenities) combined with the locale-aware [cities] from `LocalityOptions`
  /// (D12). A failure is a retryable error state — never a hardcoded fallback.
  Future<void> loadOptions(List<String> cities) async {
    if (state.options != null || state.isLoadingOptions) return;
    emit(state.copyWith(isLoadingOptions: true, optionsFailure: null));
    try {
      final listingMeta = await _listingRepository.fetchMeta();
      if (isClosed) return;
      emit(state.copyWith(
        isLoadingOptions: false,
        options: SearchFilterOptions(
          categories: listingMeta.categories,
          amenities: listingMeta.amenities,
          cities: cities,
        ),
      ));
    } on Failure catch (failure) {
      if (isClosed) return;
      emit(state.copyWith(isLoadingOptions: false, optionsFailure: failure));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        isLoadingOptions: false,
        optionsFailure: const ServerFailure(''),
      ));
    }
  }

  /// Initial load: first page with the skeleton state (FR-006). Not debounced.
  Future<void> load() async {
    await _fetchFirstPage(state.filters.copyWith(page: 1));
  }

  /// Commits new filters: resets to page 1, then a debounced (~400 ms) page-1
  /// refetch. Cancels any earlier timer so rapid changes produce exactly one
  /// request for the latest criteria (FR-004).
  Future<void> applyFilters(SearchFilters filters) async {
    _debounce?.cancel();
    final SearchFilters committed = filters.copyWith(page: 1);
    emit(state.copyWith(
      filters: committed,
      failure: null,
      transientFailure: null,
    ));
    _debounce = Timer(_debounceDuration, () {
      _fetchFirstPage(committed);
    });
  }

  /// Resets every filter (and the sort) to the empty default, then refetches
  /// page 1 newest-first — the US1 empty-state CTA and the panel "Reset".
  Future<void> resetFilters() async {
    _debounce?.cancel();
    emit(state.copyWith(
      filters: const SearchFilters(),
      failure: null,
      transientFailure: null,
    ));
    await _fetchFirstPage(const SearchFilters());
  }

  /// Loads the next page when the list is near its end. Guarded by an
  /// in-flight flag (contract `search-browse.md`); pages append, never replace.
  Future<void> loadMore() async {
    if (_loadingMore || state.isLoading || !state.hasMore) return;
    _loadingMore = true;
    emit(state.copyWith(isLoadingMore: true));
    final SearchFilters filters = state.filters.copyWith(
      page: state.filters.page + 1,
    );
    final int generation = ++_generation;
    try {
      final BrowsePage result = await _browseWithSortFallback(filters);
      if (generation != _generation || isClosed) return;
      emit(state.copyWith(
        items: [...state.items, ...result.items],
        filters: filters,
        hasMore: result.meta.page < result.meta.pages,
        loaded: true,
      ));
    } on Failure catch (failure) {
      if (generation != _generation || isClosed) return;
      emit(state.copyWith(isLoadingMore: false, failure: failure));
    } catch (_) {
      if (generation != _generation || isClosed) return;
      emit(state.copyWith(
        isLoadingMore: false,
        failure: const ServerFailure(''),
      ));
    } finally {
      _loadingMore = false;
      if (!isClosed) {
        emit(state.copyWith(isLoadingMore: false));
      }
    }
  }

  /// Fetches page 1, replacing the current list (filter change / initial /
  /// reset). Captures a generation so stale responses are dropped (D7).
  Future<void> _fetchFirstPage(SearchFilters filters) async {
    final int generation = ++_generation;
    emit(state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      loaded: false,
      items: const <BrowseListing>[],
      hasMore: false,
      failure: null,
      transientFailure: null,
    ));
    try {
      final BrowsePage result = await _browseWithSortFallback(filters);
      if (generation != _generation || isClosed) return;
      emit(state.copyWith(
        isLoading: false,
        items: result.items,
        filters: filters,
        hasMore: result.meta.page < result.meta.pages,
        loaded: true,
      ));
    } on Failure catch (failure) {
      if (generation != _generation || isClosed) return;
      emit(state.copyWith(isLoading: false, failure: failure));
    } catch (_) {
      if (generation != _generation || isClosed) return;
      emit(state.copyWith(isLoading: false, failure: const ServerFailure('')));
    }
  }

  /// D11: retries the newest sort (`createdAt:desc`) once without a sort when
  /// the backend rejects it; other sorts and failures pass through unchanged.
  Future<BrowsePage> _browseWithSortFallback(SearchFilters filters) async {
    if (_sortFallbackApplied || filters.sort == null) {
      return _listingRepository.browse(_builder.build(filters));
    }
    try {
      return await _listingRepository.browse(_builder.build(filters));
    } on Failure catch (failure) {
      if (failure is! ValidationFailure && failure is! GenericFailure) {
        rethrow;
      }
      _sortFallbackApplied = true;
      return _listingRepository.browse(
        _builder.build(filters.copyWith(sort: null)),
      );
    }
  }

  /// Optimistic heart toggle (D8, contract `saved-listings.md`): flips
  /// `isSaved` immediately, mutates only through the shared
  /// [SavedListingsRepository], and reverts + surfaces a transient localized
  /// failure on error. A single in-flight flag per listing blocks duplicate
  /// taps.
  Future<void> toggleSaved(String listingId, bool currentIsSaved) async {
    if (_savingIds.contains(listingId)) return;
    _savingIds.add(listingId);
    final int index = state.items.indexWhere((e) => e.id == listingId);
    if (index < 0) {
      _savingIds.remove(listingId);
      return;
    }
    final bool target = !currentIsSaved;
    _replaceItem(index, state.items[index].copyWith(isSaved: target));
    try {
      if (target) {
        await _savedListingsRepository.save(listingId);
      } else {
        await _savedListingsRepository.unsave(listingId);
      }
    } on Failure catch (failure) {
      _revertAndSurface(index, currentIsSaved, failure);
    } catch (_) {
      _revertAndSurface(index, currentIsSaved, const ServerFailure(''));
    } finally {
      _savingIds.remove(listingId);
    }
  }

  void _revertAndSurface(int index, bool currentIsSaved, Failure failure) {
    _replaceItem(index, state.items[index].copyWith(isSaved: currentIsSaved));
    emit(state.copyWith(transientFailure: failure));
  }

  void _replaceItem(int index, BrowseListing updated) {
    final List<BrowseListing> items = [...state.items];
    items[index] = updated;
    emit(state.copyWith(items: items));
  }

  /// Clears the transient heart-mutation failure after the screen has surfaced
  /// it (usually as a SnackBar).
  void clearTransientFailure() {
    if (state.transientFailure != null) {
      emit(state.copyWith(transientFailure: null));
    }
  }
}

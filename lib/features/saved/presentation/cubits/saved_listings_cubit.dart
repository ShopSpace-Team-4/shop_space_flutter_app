import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/saved_listing.dart';
import '../../repository/saved_listings_repository.dart';

part 'saved_listings_cubit.freezed.dart';

/// Saved-list screen state (US5, T054; contract `saved-listings.md` §US5).
///
/// The rendering states are derived from the fields: `isLoading && !loaded`
/// renders the loading state; `loaded && items.isNotEmpty` renders the list;
/// `loaded && items.isEmpty` renders the localized empty state; a non-null
/// [failure] renders the error + retry. A [transientFailure] carries an
/// optimistic-unsave failure for the screen to surface as a message before
/// clearing it via [SavedListingsCubit.clearTransientFailure].
@freezed
abstract class SavedListingsState with _$SavedListingsState {
  const factory SavedListingsState({
    @Default(false) bool isLoading,
    @Default(false) bool loaded,
    @Default(<SavedListing>[]) List<SavedListing> items,
    Failure? failure,
    Failure? transientFailure,
  }) = _SavedListingsState;
}

/// Drives the Saved screen (US5, T054). Refetches `getSavedListings()` on
/// open/refresh so unsaves from anywhere disappear (FR-013) and saves from
/// anywhere appear (SC-006). `unsave(listingId)` removes the item from the
/// loaded list optimistically, mutates only through the shared
/// [SavedListingsRepository] (D8), and reverts + surfaces a transient
/// localized failure on error.
class SavedListingsCubit extends Cubit<SavedListingsState> {
  SavedListingsCubit({required SavedListingsRepository savedListingsRepository})
    : _savedListingsRepository = savedListingsRepository,
      super(const SavedListingsState());

  final SavedListingsRepository _savedListingsRepository;

  /// Single in-flight guard per listing so a double heart tap fires exactly one
  /// mutation (FR-014, D8).
  final Set<String> _unsavingIds = <String>{};

  /// Loads the saved list (open/refresh). A failure becomes a localized
  /// error + retry (US5 scenario 4).
  Future<void> load() async {
    emit(state.copyWith(isLoading: true, failure: null));
    try {
      final List<SavedListing> items = await _savedListingsRepository
          .getSavedListings();
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, loaded: true, items: items));
    } on Failure catch (failure) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, failure: failure));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, failure: const ServerFailure('')));
    }
  }

  /// Optimistic unsave (D8, contract `saved-listings.md`): removes the item
  /// from the loaded list immediately, mutates only through the shared
  /// [SavedListingsRepository], and reverts + surfaces a transient localized
  /// failure on error. A single in-flight flag per listing blocks duplicate
  /// taps.
  Future<void> unsave(String listingId) async {
    if (_unsavingIds.contains(listingId)) return;
    _unsavingIds.add(listingId);
    final int index = state.items.indexWhere((e) => e.id == listingId);
    if (index < 0) {
      _unsavingIds.remove(listingId);
      return;
    }
    final SavedListing original = state.items[index];
    _removeAt(index);
    try {
      await _savedListingsRepository.unsave(listingId);
    } on Failure catch (failure) {
      _revertAndSurface(index, original, failure);
    } catch (_) {
      _revertAndSurface(index, original, const ServerFailure(''));
    } finally {
      _unsavingIds.remove(listingId);
    }
  }

  void _removeAt(int index) {
    final List<SavedListing> items = [...state.items]..removeAt(index);
    emit(state.copyWith(items: items));
  }

  void _revertAndSurface(int index, SavedListing original, Failure failure) {
    final List<SavedListing> items = [...state.items];
    items.insert(index.clamp(0, items.length), original);
    emit(state.copyWith(items: items, transientFailure: failure));
  }

  /// Clears the transient unsave failure after the screen has surfaced it
  /// (usually as a SnackBar).
  void clearTransientFailure() {
    if (state.transientFailure != null) {
      emit(state.copyWith(transientFailure: null));
    }
  }
}

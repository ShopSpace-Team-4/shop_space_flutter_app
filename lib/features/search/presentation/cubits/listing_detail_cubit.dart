import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../../listing/data/models/shop_listing.dart';
import '../../../listing/repository/listing_repository.dart';
import '../../../saved/repository/saved_listings_repository.dart';

part 'listing_detail_cubit.freezed.dart';

/// Tenant detail state (data-model §3.x, contract `responsive-search-layout.md`).
///
/// The rendering states are derived from the fields: a non-null [listing] renders
/// the full [ShopListing]; [isUnavailable] renders the friendly "no longer
/// available" + return-to-results state (US2 scenario 4); a non-null [failure]
/// renders the localized error + retry; otherwise the surface is loading.
@freezed
abstract class ListingDetailState with _$ListingDetailState {
  const factory ListingDetailState({
    @Default(false) bool isLoading,
    ShopListing? listing,

    /// Set when `GET /listings/:id` surfaces [ListingNotFound] — the shop was
    /// deleted or is no longer AVAILABLE (data-model §3.4).
    @Default(false) bool isUnavailable,
    Failure? failure,

    /// Set when an optimistic heart mutation fails (D8) — the surface surfaces
    /// it as a localized message and then calls
    /// [ListingDetailCubit.clearTransientFailure].
    Failure? transientFailure,
  }) = _ListingDetailState;
}

/// Drives the tenant listing detail (US2, T027). Reuses `ListingRepository`
/// (`getListing`) — never a duplicate browse/detail repository (D2) — plus the
/// shared [SavedListingsRepository] for the heart (D8).
///
/// Responsibilities:
/// - `load(listingId)` → `getListing(id)`; renders the full `ShopListing` on
///   success, maps [ListingNotFound] to the dedicated unavailable state, and
///   maps every other failure to a localized error + retry;
/// - `toggleSaved()` mirrors the optimistic flip + revert protocol (D8) for the
///   single open listing;
/// - `clear()` resets to the initial state (expanded in-pane deselection).
class ListingDetailCubit extends Cubit<ListingDetailState> {
  ListingDetailCubit({
    required ListingRepository listingRepository,
    required SavedListingsRepository savedListingsRepository,
  })  : _listingRepository = listingRepository,
        _savedListingsRepository = savedListingsRepository,
        super(const ListingDetailState());

  final ListingRepository _listingRepository;
  final SavedListingsRepository _savedListingsRepository;

  /// Single in-flight guard so a double heart tap fires exactly one mutation
  /// (FR-014, D8).
  bool _saving = false;

  /// Loads the full listing for [listingId]. A [ListingNotFound] becomes the
  /// unavailable state (US2 scenario 4); anything else becomes a retryable
  /// error (FR-014).
  Future<void> load(String listingId) async {
    emit(const ListingDetailState(isLoading: true));
    try {
      final ShopListing listing = await _listingRepository.getListing(listingId);
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, listing: listing));
    } on ListingNotFound {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, isUnavailable: true));
    } on Failure catch (failure) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, failure: failure));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, failure: const ServerFailure('')));
    }
  }

  /// Optimistic heart toggle (D8, contract `saved-listings.md`): flips the
  /// open listing's `isSaved` immediately, mutates only through the shared
  /// [SavedListingsRepository], and reverts + surfaces a transient localized
  /// failure on error. A single in-flight flag blocks duplicate taps.
  Future<void> toggleSaved() async {
    final ShopListing? listing = state.listing;
    if (listing == null || _saving) return;
    _saving = true;
    final bool currentIsSaved = listing.isSaved == true;
    final bool target = !currentIsSaved;
    emit(state.copyWith(listing: listing.copyWith(isSaved: target)));
    try {
      if (target) {
        await _savedListingsRepository.save(listing.id);
      } else {
        await _savedListingsRepository.unsave(listing.id);
      }
    } on Failure catch (failure) {
      _revertAndSurface(listing, failure);
    } catch (_) {
      _revertAndSurface(listing, const ServerFailure(''));
    } finally {
      _saving = false;
    }
  }

  void _revertAndSurface(ShopListing original, Failure failure) {
    emit(state.copyWith(listing: original, transientFailure: failure));
  }

  /// Clears the transient heart-mutation failure after the surface has surfaced
  /// it (usually as a SnackBar).
  void clearTransientFailure() {
    if (state.transientFailure != null) {
      emit(state.copyWith(transientFailure: null));
    }
  }

  /// Resets to the initial state — used by the expanded in-pane surface when
  /// the selection is cleared (back to the "select a shop" placeholder).
  void clear() {
    emit(const ListingDetailState());
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/listing_status.dart';
import '../../data/models/listing_summary.dart';
import '../../data/models/shop_listing.dart';
import '../../repository/listing_repository.dart';

part 'my_listings_cubit.freezed.dart';

/// Home base for a landlord (US2): owns the My Listings summary list plus the
/// currently selected detail, and applies status changes (D4). Status success
/// updates the local [ListingSummary] and the open [ShopListing] in place so
/// the UI converges without a full reload (listing-status.md); a rejected
/// transition surfaces a typed `ListingStatusFailed` and both the list and the
/// open detail are re-fetched so they converge with the server
/// (backend-authoritative D4). US4 adds delete-with-confirmation (FR-012): a
/// successful delete removes the [ListingSummary] and clears the open detail;
/// failures surface `ListingDeleteFailed`/`ListingNotFound`/`ListingNotOwned`
/// via [MyListingsState.deleteFailure].
@freezed
abstract class MyListingsState with _$MyListingsState {
  const factory MyListingsState({
    @Default(false) bool isLoading,
    @Default([]) List<ListingSummary> listings,
    Failure? listFailure,
    @Default(false) bool isSubmitting,
    Failure? statusFailure,
    Failure? deleteFailure,
    @Default(false) bool detailLoading,
    ShopListing? detail,
    Failure? detailFailure,
  }) = _MyListingsState;
}

class MyListingsCubit extends Cubit<MyListingsState> {
  MyListingsCubit({required ListingRepository repository})
      : _repository = repository,
        super(const MyListingsState());

  final ListingRepository _repository;

  /// Loads (or refreshes) the My Listings summary list. Idempotent — a second
  /// tap while loading is ignored (FR-014).
  Future<void> loadList() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, listFailure: null));
    try {
      final List<ListingSummary> listings = await _repository.getMyListings();
      emit(MyListingsState(
        listings: listings,
        detail: state.detail,
        detailFailure: state.detailFailure,
        statusFailure: state.statusFailure,
        deleteFailure: state.deleteFailure,
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(isLoading: false, listFailure: failure));
    } catch (_) {
      emit(state.copyWith(isLoading: false, listFailure: const ServerFailure('')));
    }
  }

  /// Loads the full detail for [id] into [MyListingsState.detail] (two-pane
  /// detail or the pushed detail screen's data source).
  Future<void> loadDetail(String id) async {
    emit(state.copyWith(
      detailLoading: true,
      detailFailure: null,
      detail: null,
    ));
    try {
      final ShopListing listing = await _repository.getListing(id);
      emit(state.copyWith(detailLoading: false, detail: listing));
    } on Failure catch (failure) {
      emit(state.copyWith(detailLoading: false, detailFailure: failure));
    } catch (_) {
      emit(
        state.copyWith(
          detailLoading: false,
          detailFailure: const ServerFailure(''),
        ),
      );
    }
  }

  /// Applies a status change through the backend (D4). On success the local
  /// summary and open detail are updated in place; on a rejected transition
  /// the list AND the open detail are re-fetched so the UI converges with the
  /// server's actual state (T062, listing-status.md). [MyListingsState.statusFailure]
  /// is preserved through the convergence so the UI can surface the localized
  /// `ListingStatusFailed`.
  Future<void> changeStatus(String id, ListingStatus status) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, statusFailure: null));
    try {
      await _repository.changeStatus(id, status);
      emit(
        state.copyWith(
          isSubmitting: false,
          listings: [
            for (final ListingSummary summary in state.listings)
              summary.id == id
                  ? summary.copyWith(status: status)
                  : summary,
          ],
          detail: state.detail != null && state.detail!.id == id
              ? state.detail!.copyWith(status: status)
              : state.detail,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(isSubmitting: false, statusFailure: failure));
      await _convergeAfterRejectedStatus(id);
    } catch (_) {
      emit(state.copyWith(isSubmitting: false, statusFailure: const ServerFailure('')));
      await _convergeAfterRejectedStatus(id);
    }
  }

  /// Deletes a listing after the UI confirmed it (FR-012, T060): removes the
  /// [ListingSummary] from the local list and clears the open detail when it
  /// was the deleted listing. Guarded by the same in-flight [MyListingsState.isSubmitting]
  /// flag as every other destructive action (FR-014); failures surface typed
  /// `ListingDeleteFailed`/`ListingNotFound`/`ListingNotOwned` through
  /// [MyListingsState.deleteFailure].
  Future<void> deleteListing(String id) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, deleteFailure: null));
    try {
      await _repository.deleteListing(id);
      emit(
        state.copyWith(
          isSubmitting: false,
          listings: [
            for (final ListingSummary summary in state.listings)
              if (summary.id != id) summary,
          ],
          detail: state.detail?.id == id ? null : state.detail,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(isSubmitting: false, deleteFailure: failure));
    } catch (_) {
      emit(state.copyWith(isSubmitting: false, deleteFailure: const ServerFailure('')));
    }
  }

  /// Backend-authoritative convergence (D4/T062): after a rejected transition,
  /// re-fetch the summary list AND the open detail so both reflect the
  /// server's real status. The status failure is kept in state for surfacing.
  Future<void> _convergeAfterRejectedStatus(String id) async {
    final ShopListing? openDetail = state.detail;
    await loadList();
    if (openDetail != null && openDetail.id == id) {
      await loadDetail(id);
    }
  }

  /// Pull-to-refresh alias.
  Future<void> refresh() => loadList();
}

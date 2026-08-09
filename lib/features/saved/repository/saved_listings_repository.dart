import '../data/models/saved_listing.dart';

/// Application use-case surface for save/unsave/saved-list (contract
/// `contracts/saved-listings.md`). A repository interface method IS the use
/// case (constitution §Architecture). Methods surface only typed failures —
/// never raw exceptions (guaranteed by [SavedListingsDataSource]).
///
/// THIS one repository instance is injected into every surface that shows a
/// heart or saved state (D8): `SearchCubit`, tenant `ListingDetailCubit`,
/// home card heart, `SavedListingsCubit`. Tapping a heart mutates ONLY
/// through here, never a local copy.
abstract class SavedListingsRepository {
  /// `POST /listings/:id/save` — idempotent (§7.1).
  Future<void> save(String listingId);

  /// `DELETE /listings/:id/save` — idempotent (§7.2).
  Future<void> unsave(String listingId);

  /// `GET /users/me/saved-listings` — bare array, no pagination meta.
  Future<List<SavedListing>> getSavedListings();
}

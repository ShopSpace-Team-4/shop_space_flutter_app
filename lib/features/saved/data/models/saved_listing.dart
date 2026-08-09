import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_listing.freezed.dart';
part 'saved_listing.g.dart';

/// One saved listing item from `GET /users/me/saved-listings` (contract
/// `contracts/saved-listings.md` §7.3 / D3). Deliberately NOT a reuse of
/// [BrowseListing] or `ShopListing` — this is the slim saved payload
/// (`id, title, location, annualRent, annualRentWithVat, currency,
/// areaSqm, thumbnailUrl, isSaved`). The same model flows unchanged into
/// `repository/` and `presentation/` (no DTO mapping).
///
/// `location` is the combined `"New Cairo, Cairo"` string from the backend;
/// the saved screen reads it independently of search (spec Q1).
@freezed
abstract class SavedListing with _$SavedListing {
  const factory SavedListing({
    required String id,
    required String title,
    required String location,
    required double annualRent,
    required double annualRentWithVat,
    required String currency,
    required double areaSqm,
    String? thumbnailUrl,
    bool? isSaved,
  }) = _SavedListing;

  factory SavedListing.fromJson(Map<String, dynamic> json) =>
      _$SavedListingFromJson(json);
}

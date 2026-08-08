import 'package:freezed_annotation/freezed_annotation.dart';

part 'browse_listing.freezed.dart';
part 'browse_listing.g.dart';

/// One marketplace listing item from `GET /listings` (the browse endpoint,
/// data-model.md §1.x / FRONTEND_PHASE2_LISTINGS_API_GUIDE.md §5.2). Deliberately
/// slimmer than [ShopListing] — it mirrors the browse payload, which has no
/// amenities/media/status. The same model flows unchanged into `repository/`
/// and `presentation/` (no DTO mapping).
@freezed
abstract class BrowseListing with _$BrowseListing {
  const factory BrowseListing({
    required String id,
    required String title,
    required String category,
    required double areaSqm,
    required String city,
    required String district,
    required double annualRent,
    required double annualRentWithVat,
    required String currency,
    String? thumbnailUrl,
    bool? isSaved,
  }) = _BrowseListing;

  factory BrowseListing.fromJson(Map<String, dynamic> json) =>
      _$BrowseListingFromJson(json);
}

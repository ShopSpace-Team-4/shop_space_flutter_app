import 'package:freezed_annotation/freezed_annotation.dart';

import 'listing_media.dart';
import 'listing_status.dart';

part 'shop_listing.freezed.dart';
part 'shop_listing.g.dart';

/// Full listing detail (response model for `GET /listings/:id`). The same
/// model flows unchanged into `repository/` and `presentation/` (data-model.md
/// §1.3) — no DTO mapping.
@freezed
abstract class ShopListing with _$ShopListing {
  const factory ShopListing({
    required String id,
    String? landlordId,
    required String title,
    required String category,
    required double areaSqm,
    required String city,
    required String district,
    String? address,
    String? description,
    required List<String> amenities,
    int? numberOfFloors,
    required int floorNumber,
    DateTime? availableFrom,
    String? minimumLeaseTerm,
    required double annualRent,
    required double annualRentWithVat,
    required String currency,
    int? securityDepositMonths,
    @ListingStatusConverter() required ListingStatus status,
    required List<ListingMedia> media,
    String? thumbnailUrl,
    bool? isSaved,
  }) = _ShopListing;

  factory ShopListing.fromJson(Map<String, dynamic> json) =>
      _$ShopListingFromJson(json);
}

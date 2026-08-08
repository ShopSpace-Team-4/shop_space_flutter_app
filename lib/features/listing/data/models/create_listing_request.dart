import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_listing_request.freezed.dart';
part 'create_listing_request.g.dart';

/// Body for `POST /listings` (data-model.md §2). The new listing always starts
/// PENDING server-side (FR-006); `annualRentWithVat` and `status` are never in
/// the create payload.
@freezed
abstract class CreateListingRequest with _$CreateListingRequest {
  const factory CreateListingRequest({
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
    String? availableFrom,
    String? minimumLeaseTerm,
    required double annualRent,
    required String currency,
    int? securityDepositMonths,
  }) = _CreateListingRequest;

  factory CreateListingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateListingRequestFromJson(json);
}

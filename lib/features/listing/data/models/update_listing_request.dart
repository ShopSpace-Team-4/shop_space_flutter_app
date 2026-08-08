import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_listing_request.freezed.dart';
part 'update_listing_request.g.dart';

/// Body for `PUT /listings/:id` (data-model.md §2). Same field set as the
/// create payload; `status` is NEVER included — an edit never changes a
/// listing's status (FR-010).
@freezed
abstract class UpdateListingRequest with _$UpdateListingRequest {
  const factory UpdateListingRequest({
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
    @JsonKey(includeIfNull: false) String? currency,
    int? securityDepositMonths,
  }) = _UpdateListingRequest;

  factory UpdateListingRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateListingRequestFromJson(json);
}

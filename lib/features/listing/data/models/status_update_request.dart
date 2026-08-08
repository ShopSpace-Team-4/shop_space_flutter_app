import 'package:freezed_annotation/freezed_annotation.dart';

import 'listing_status.dart';

part 'status_update_request.freezed.dart';
part 'status_update_request.g.dart';

/// Body for `PATCH /listings/:id/status`. The backend is authoritative on
/// transitions (D4) — the app sends the chosen value verbatim.
@freezed
abstract class StatusUpdateRequest with _$StatusUpdateRequest {
  const factory StatusUpdateRequest({
    @ListingStatusConverter() required ListingStatus status,
  }) = _StatusUpdateRequest;

  factory StatusUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$StatusUpdateRequestFromJson(json);
}

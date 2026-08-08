import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_order_request.freezed.dart';
part 'media_order_request.g.dart';

/// Entry of the full desired media order for `PUT /listings/:id/media/reorder`
/// — the complete final order, not deltas (media-upload.md).
@freezed
abstract class MediaOrderEntry with _$MediaOrderEntry {
  const factory MediaOrderEntry({
    required String mediaId,
    required int sortOrder,
  }) = _MediaOrderEntry;

  factory MediaOrderEntry.fromJson(Map<String, dynamic> json) =>
      _$MediaOrderEntryFromJson(json);
}

/// Body for `PUT /listings/:id/media/reorder`. `mediaId` is the `_id` returned
/// by the upload/listing response (`ListingMedia.id`).
@freezed
abstract class MediaOrderRequest with _$MediaOrderRequest {
  const factory MediaOrderRequest({
    required List<MediaOrderEntry> media,
  }) = _MediaOrderRequest;

  factory MediaOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$MediaOrderRequestFromJson(json);
}

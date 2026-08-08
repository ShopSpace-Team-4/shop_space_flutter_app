import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing_media.freezed.dart';
part 'listing_media.g.dart';

/// One media item on a listing (response model for `POST/GET/DELETE media` and
/// the reorder response). The JSON `_id` is the `mediaId` used by reorder and
/// delete (data-model.md §1.2, D3).
@freezed
abstract class ListingMedia with _$ListingMedia {
  const factory ListingMedia({
    @JsonKey(name: '_id') required String id,
    required String mediaType,
    required String url,
    required int sortOrder,
  }) = _ListingMedia;

  factory ListingMedia.fromJson(Map<String, dynamic> json) =>
      _$ListingMediaFromJson(json);
}

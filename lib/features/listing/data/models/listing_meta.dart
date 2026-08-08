import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing_meta.freezed.dart';
part 'listing_meta.g.dart';

/// Options response for `GET /listings/meta` (the `{ success, data }` envelope
/// exception — already unwrapped by the pipeline, D2). City/district options
/// are not published here; the form uses a local curated EN/AR list (flagged
/// gap).
@freezed
abstract class ListingMeta with _$ListingMeta {
  const factory ListingMeta({
    required List<String> categories,
    required List<String> amenities,
    required List<String> statuses,
  }) = _ListingMeta;

  factory ListingMeta.fromJson(Map<String, dynamic> json) =>
      _$ListingMetaFromJson(json);
}

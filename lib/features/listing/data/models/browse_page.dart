import 'package:freezed_annotation/freezed_annotation.dart';

import 'browse_listing.dart';

part 'browse_page.freezed.dart';
part 'browse_page.g.dart';

/// Paginated browse response for `GET /listings`: `{ items: [BrowseListing],
/// meta: { page, limit, total, pages } }` (API guide §5.2).
@freezed
abstract class BrowsePage with _$BrowsePage {
  const factory BrowsePage({
    required List<BrowseListing> items,
    required BrowseMeta meta,
  }) = _BrowsePage;

  factory BrowsePage.fromJson(Map<String, dynamic> json) =>
      _$BrowsePageFromJson(json);
}

/// Pagination metadata of a [BrowsePage].
@freezed
abstract class BrowseMeta with _$BrowseMeta {
  const factory BrowseMeta({
    required int page,
    required int limit,
    required int total,
    required int pages,
  }) = _BrowseMeta;

  factory BrowseMeta.fromJson(Map<String, dynamic> json) =>
      _$BrowseMetaFromJson(json);
}

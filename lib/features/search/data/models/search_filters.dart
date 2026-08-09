import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filters.freezed.dart';

/// Selectable sort orders (D11). Wire values match the `sort=field:direction`
/// grammar of `GET /listings` (API guide §5.2). Newest is the default — the
/// `SearchCubit`/`SearchFilterBuilder` fall back to no sort if the backend
/// rejects `createdAt:desc`.
enum SearchSort {
  newest('createdAt:desc'),
  priceAsc('annualRent:asc'),
  priceDesc('annualRent:desc');

  const SearchSort(this.wire);

  /// The `sort=…` query value sent to the browse endpoint.
  final String wire;

  /// Resolves a stored wire value back to an enum; `null`/unknown → [newest].
  static SearchSort fromWire(String? wire) {
    if (wire == null) return SearchSort.newest;
    return SearchSort.values.firstWhere(
      (SearchSort s) => s.wire == wire,
      orElse: () => SearchSort.newest,
    );
  }
}

/// User-facing filter state on the Search screen (data-model §1.1). Converts
/// 1:1 into `BrowseQuery` via `SearchFilterBuilder` (contract
/// `search-browse.md`). The empty default `SearchFilters()` means "all
/// available shops, newest first".
///
/// `page` is owned by the cubit (advanced as pages append); `limit` is fixed
/// at 10 (matches the browse default). Range validation (`max > min` when both
/// are set) lives in the filter panel, never here (data-model §1.1).
@freezed
abstract class SearchFilters with _$SearchFilters {
  const factory SearchFilters({
    String? city,
    String? district,
    String? category,
    double? priceMin,
    double? priceMax,
    double? areaMin,
    double? areaMax,
    @Default(<String>[]) List<String> amenities,
    String? sort,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _SearchFilters;
}

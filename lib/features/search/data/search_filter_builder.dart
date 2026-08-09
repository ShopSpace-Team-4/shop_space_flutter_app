import '../../listing/data/models/browse_query.dart';
import 'models/search_filters.dart';

/// Converts [SearchFilters] → [BrowseQuery] 1:1 (contract `search-browse.md`,
/// D11). `status` stays `AVAILABLE` (fixed — only available shops are
/// discoverable, FR-001); unset filters are omitted by
/// `BrowseQuery.toQueryParameters()`. The `double?` range fields are rounded
/// to the `int?` fields `BrowseQuery` carries.
class SearchFilterBuilder {
  const SearchFilterBuilder();

  /// Builds the browse query for [filters]. A `null` sort (the empty default)
  /// resolves to newest-first (`createdAt:desc`, D11); `limit` stays fixed at
  /// the browse default of 10.
  BrowseQuery build(SearchFilters filters) {
    return BrowseQuery(
      category: filters.category,
      city: filters.city,
      district: filters.district,
      priceMin: filters.priceMin?.round(),
      priceMax: filters.priceMax?.round(),
      areaMin: filters.areaMin?.round(),
      areaMax: filters.areaMax?.round(),
      amenities: filters.amenities,
      page: filters.page,
      limit: filters.limit,
      sort: filters.sort ?? SearchSort.newest.wire,
    );
  }
}

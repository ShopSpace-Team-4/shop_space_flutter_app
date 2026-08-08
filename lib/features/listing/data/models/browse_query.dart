import 'listing_status.dart';

/// Filter/sort/pagination parameters for the browse endpoint `GET /listings`
/// (API guide §5.2). Immutable value object; [toQueryParameters] produces the
/// wire query string. Defaults: `status=AVAILABLE`, `page=1`, `limit=10` so a
/// bare `const BrowseQuery()` fetches the first page of available shops.
class BrowseQuery {
  const BrowseQuery({
    this.category,
    this.city,
    this.district,
    this.priceMin,
    this.priceMax,
    this.areaMin,
    this.areaMax,
    this.status = ListingStatus.available,
    this.amenities = const [],
    this.page = 1,
    this.limit = 10,
    this.sort,
  });

  final String? category;
  final String? city;
  final String? district;
  final int? priceMin;
  final int? priceMax;
  final int? areaMin;
  final int? areaMax;
  final ListingStatus status;

  /// Filter by amenities (e.g. `["PARKING", "AC"]` — the enum values from
  /// `GET /listings/meta`). Sent comma-joined as `amenities=PARKING,AC`.
  final List<String> amenities;
  final int page;
  final int limit;

  /// Sort expression, e.g. `"annualRent:asc"`.
  final String? sort;

  /// Wire query parameters, omitting unset filters.
  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (category != null) 'category': category,
      if (city != null) 'city': city,
      if (district != null) 'district': district,
      if (priceMin != null) 'priceMin': '$priceMin',
      if (priceMax != null) 'priceMax': '$priceMax',
      if (areaMin != null) 'areaMin': '$areaMin',
      if (areaMax != null) 'areaMax': '$areaMax',
      'status': status.apiValue,
      if (amenities.isNotEmpty) 'amenities': amenities.join(','),
      'page': '$page',
      'limit': '$limit',
      if (sort != null) 'sort': sort,
    };
  }
}

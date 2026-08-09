/// The fields a free-text search-bar query can resolve into (Figma 97:5219).
///
/// A plain value object — deliberately NOT freezed (no codegen needed) and not
/// an entity: it only carries the three slots the bar can drive.
class SearchQueryResolution {
  const SearchQueryResolution({this.city, this.district, this.category});

  final String? city;
  final String? district;
  final String? category;

  /// Whether the query resolved at least one slot.
  bool get isEmpty => city == null && district == null && category == null;
}

/// Resolves a free-text quick-filter query into existing city / district /
/// category filter slots (locked search-bar behavior, Figma 97:5219).
///
/// Rules:
/// - the query is whitespace-split into tokens;
/// - each token fills at most one slot, in priority order: city, then district
///   (scoped to the resolved city, falling back to every city's districts),
///   then category — the first slot a token matches wins, then the token stops;
/// - within a slot, a case-insensitive **exact** match wins, then a **prefix**
///   match of at least 2 characters (so "Nasr", "Sheikh", "6th" work);
/// - the first token to fill a slot wins; later tokens never refill it;
/// - unmatched tokens are ignored.
///
/// Pure and dependency-free: no freezed, no dio, no widget tree. The screen
/// supplies the locale-aware option sources (`SearchFilterOptions.cities` +
/// `.districtsFor` + `.categories`).
abstract final class SearchQueryResolver {
  static SearchQueryResolution resolve({
    required String query,
    required List<String> cities,
    required List<String> Function(String city) districtsFor,
    required List<String> categories,
  }) {
    String? city;
    String? district;
    String? category;

    final List<String> allDistricts = <String>[
      for (final String c in cities) ...districtsFor(c),
    ];

    for (final String token in query
        .split(RegExp(r'\s+'))
        .where((String t) => t.isNotEmpty)) {
      if (city == null) {
        final String? match = _match(token, cities);
        if (match != null) {
          city = match;
          continue;
        }
      }
      if (district == null) {
        final List<String> pool = city == null ? allDistricts : districtsFor(city);
        final String? match = _match(token, pool);
        if (match != null) {
          district = match;
          continue;
        }
      }
      if (category == null) {
        final String? match = _match(token, categories);
        if (match != null) {
          category = match;
          continue;
        }
      }
    }

    return SearchQueryResolution(
      city: city,
      district: district,
      category: category,
    );
  }

  /// Exact match first, then a ≥2-character prefix match (case-insensitive).
  /// Returns the canonical option string on a hit, else null.
  static String? _match(String token, List<String> options) {
    final String normalized = token.toLowerCase();
    for (final String option in options) {
      if (option.toLowerCase() == normalized) return option;
    }
    if (token.length < 2) return null;
    for (final String option in options) {
      if (option.toLowerCase().startsWith(normalized)) return option;
    }
    return null;
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../listing/data/locality_options.dart';

part 'search_filter_options.freezed.dart';

/// Bundles the option sources for the Search filter UI (data-model §1.2,
/// contract `search-browse.md`):
/// - [categories] / [amenities] — from `GET /listings/meta` via
///   `ListingRepository.fetchMeta`;
/// - [cities] + [districtsFor] — from the local curated `LocalityOptions`
///   (flagged gap D12 — never a hardcoded fallback list).
///
/// Loaded once when the Search screen first opens; a fetch failure is a
/// retryable error state, not a fallback.
@freezed
abstract class SearchFilterOptions with _$SearchFilterOptions {
  const factory SearchFilterOptions({
    required List<String> categories,
    required List<String> amenities,
    required List<String> cities,
  }) = _SearchFilterOptions;
}

/// Locale-aware district lookup for a selected [SearchFilterOptions.cities]
/// entry, backed by the local curated list (D12). An extension (not a class
/// member) so the freezed-generated class — which `implements` the abstract
/// type — stays a plain value object.
extension SearchFilterOptionsX on SearchFilterOptions {
  List<String> districtsFor(String city, AppLocalizations l10n) =>
      LocalityOptions.districtsFor(l10n, city);
}

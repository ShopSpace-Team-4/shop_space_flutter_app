import '../../../../core/localization/app_localizations.dart';

/// Localized label for a known amenity value from `GET /listings/meta`
/// (listing-form.md §Field set). Unknown values fall back to the raw string so
/// forward-compatible amenities never render as blank.
String amenityLabel(AppLocalizations l10n, String amenity) => switch (amenity) {
      'PARKING' => l10n.amenityParking,
      'SECURITY' => l10n.amenitySecurity,
      'AC' => l10n.amenityAc,
      _ => amenity,
    };

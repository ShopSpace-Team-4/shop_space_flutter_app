import '../../../core/localization/app_localizations.dart';

/// Curated EN/AR city + district options for the required create-form
/// dropdowns (FR-005, listing-form.md).
///
/// `GET /listings/meta` does NOT publish city/district options, so the app
/// ships a local list (flagged gap — research.md Open items). The backend
/// team is asked to add these to `meta` so the app can drop this file later.
/// The list is intentionally small and representative for the MVP; it is
/// displayed via `AppLocalizations` for full EN/AR (RTL) parity.
abstract final class LocalityOptions {
  static bool _isArabic(AppLocalizations l10n) =>
      l10n.localeName.startsWith('ar');

  static List<String> cities(AppLocalizations l10n) =>
      _isArabic(l10n) ? _arabicCities : _englishCities;

  /// Districts grouped per city, in the same order as [cities].
  static List<String> districtsFor(AppLocalizations l10n, String city) {
    final bool ar = _isArabic(l10n);
    final List<String> cities = ar ? _arabicCities : _englishCities;
    final int index = cities.indexOf(city);
    if (index < 0 || index >= (ar ? _arabicDistricts : _englishDistricts).length) {
      return const [];
    }
    return ar ? _arabicDistricts[index] : _englishDistricts[index];
  }

  static const List<String> _englishCities = [
    'Cairo',
    'Giza',
    'Alexandria',
    '6th of October',
  ];

  static const List<List<String>> _englishDistricts = [
    ['Downtown', 'Nasr City', 'Maadi', 'Heliopolis', 'Zamalek'],
    ['Dokki', 'Mohandessin', 'Sheikh Zayed', 'Agouza'],
    ['Smouha', 'Montaza', 'Sidi Gaber', 'Gleem'],
    ['6th of October City', 'Sheikh Zayed', 'Hadayek El Ahram'],
  ];

  static const List<String> _arabicCities = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'السادس من أكتوبر',
  ];

  static const List<List<String>> _arabicDistricts = [
    ['وسط البلد', 'مدينة نصر', 'المعادي', 'مصر الجديدة', 'الزمالك'],
    ['الدقي', 'المهندسين', 'الشيخ زايد', 'العجوزة'],
    ['سموحة', 'المنتزه', 'سيدي جابر', 'جليم'],
    ['مدينة السادس من أكتوبر', 'الشيخ زايد', 'حدائق الأهرام'],
  ];
}

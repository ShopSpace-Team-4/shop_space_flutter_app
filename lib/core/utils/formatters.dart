import 'package:intl/intl.dart';

import '../localization/app_localizations.dart';

/// The ONE locale-aware number/price/date formatting surface for Phase 3 screens
/// (D9, contract `contracts/arabic-number-formatting.md`). Resolves the Phase 2
/// gap-log #6/#7 (Latin-only compact `K`, no Arabic-Indic digits).
///
/// Rules:
/// - Arabic-Indic digit conversion happens via `intl` `NumberFormat` with the
///   active locale (`ar_EG` renders `٦٩٠٬٠٠٠`, English `690,000`) — never a
///   hand-rolled digit map.
/// - `annualRentWithVat` is display-only (FR-003): these helpers READ it,
///   nothing here submits or stores it.
/// - Every helper returns a plain string, never layout (RTL text direction is
///   owned by the app's locale handling).
abstract final class Formatters {
  static bool _isArabic(AppLocalizations l10n) =>
      l10n.localeName.startsWith('ar');

  /// The `intl` locale actually used for number/date formatting. `ar_EG` is
  /// required for Arabic-Indic digits (`ar` alone renders Latin digits).
  static String _intlLocale(AppLocalizations l10n) =>
      _isArabic(l10n) ? 'ar_EG' : 'en';

  /// Renders a price with the locale's currency symbol: EN `EGP 690,000`,
  /// AR `٦٩٠٬٠٠٠ ج.م`. [compact] switches to [formatPriceCompact].
  static String formatPrice(
    double value,
    AppLocalizations l10n, {
    bool compact = false,
  }) {
    if (compact) return formatPriceCompact(value, l10n);
    final String number =
        NumberFormat.decimalPattern(_intlLocale(l10n)).format(value);
    return _isArabic(l10n)
        ? '$number $_currencySymbolArabic'
        : '$_currencySymbolEnglish $number';
  }

  /// Compact price: EN `690K`, AR `٦٩٠ ألف` (localized suffix, no Latin-only
  /// `K` token — gap-log #7).
  static String formatPriceCompact(double value, AppLocalizations l10n) =>
      NumberFormat.compact(locale: _intlLocale(l10n)).format(value);

  /// Renders an area in square meters: EN `120 m²`, AR `١٢٠ م²`. Reuses the
  /// existing localized area template (`detailAreaValue`) for the unit label.
  static String formatArea(double value, AppLocalizations l10n) =>
      l10n.detailAreaValue(
        NumberFormat.decimalPattern(_intlLocale(l10n)).format(value),
      );

  /// Renders a localized date: EN `Aug 9, 2026`, AR `٩ أغسطس ٢٠٢٦` (Arabic-
  /// Indic digits via the `ar_EG` locale).
  static String formatDate(DateTime value, AppLocalizations l10n) =>
      DateFormat.yMMMd(_intlLocale(l10n)).format(value);

  /// Renders the security-deposit months: EN `3 months`, AR `٣ أشهر`. A
  /// `null`/absent value renders the shared "not available" label.
  static String formatDeposit(int? months, AppLocalizations l10n) {
    if (months == null) return l10n.detailNotAvailable;
    final String number =
        NumberFormat.decimalPattern(_intlLocale(l10n)).format(months);
    return '$number ${l10n.detailMonths}';
  }

  /// Renders the minimum lease term. The backend carries it as free text
  /// (user-entered from the listing form, e.g. "12 months" / "سنة") so it is
  /// passed through as-is; `null`/empty renders the shared "not available"
  /// label.
  static String formatLease(String? term, AppLocalizations l10n) {
    if (term == null || term.trim().isEmpty) return l10n.detailNotAvailable;
    return term.trim();
  }

  static const String _currencySymbolEnglish = 'EGP';
  static const String _currencySymbolArabic = 'ج.م';
}

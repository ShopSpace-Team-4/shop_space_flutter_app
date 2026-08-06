import '../localization/app_localizations.dart';

/// Client-side form validation + normalization rules (spec Q1/Q2, D4).
///
/// All messages come from [AppLocalizations] — never hardcoded. Phone is
/// canonicalized to the Egyptian `+20` international form the API expects.
class FormValidators {
  const FormValidators(this.l10n);

  final AppLocalizations l10n;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return l10n.authNameRequired;
    }
    return null;
  }

  String? email(String? value) {
    final String? trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty || !_emailPattern.hasMatch(trimmed)) {
      return l10n.authInvalidEmail;
    }
    return null;
  }

  /// Full strength rule: ≥8 chars, ≥1 letter, ≥1 digit (Q2/D4). Used on
  /// signup and change-password.
  String? password(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.authPasswordRequired;
    }
    if (value.length < 8) {
      return l10n.authPasswordTooShort;
    }
    if (!value.contains(RegExp(r'[A-Za-z]'))) {
      return l10n.authPasswordRequiresLetter;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return l10n.authPasswordRequiresDigit;
    }
    return null;
  }

  /// Non-empty only (login and reset-password use the strength rule on the
  /// newly chosen password, never on the existing one).
  String? passwordRequired(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.authPasswordRequired;
    }
    return null;
  }

  String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.authOtpCodeRequired;
    }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return l10n.authOtpCodeLength;
    }
    return null;
  }

  /// Validates an Egyptian phone; also canonicalizes via [normalizePhone].
  String? phone(String? value) {
    final String? digits = value?.replaceAll(RegExp(r'\D'), '');
    if (digits == null || digits.isEmpty) {
      return l10n.authInvalidPhone;
    }
    return normalizePhone(digits) == null ? l10n.authInvalidPhone : null;
  }

  /// Canonicalizes digits-only input to international `+20` form, or returns
  /// null when invalid. Accepts `+201000000000` / `201000000000` (12 digits
  /// starting `20`) or the local `01000000000` (11 digits starting `01`) (D4).
  static String? normalizePhone(String digits) {
    if (digits.length == 12 && digits.startsWith('20')) {
      return '+$digits';
    }
    if (digits.length == 11 && digits.startsWith('01')) {
      return '+2${digits.substring(1)}';
    }
    return null;
  }
}

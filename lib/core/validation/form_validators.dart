import '../localization/app_localizations.dart';

/// Client-side form validation + normalization rules (spec Q1/Q2, D4).
///
/// All messages come from [AppLocalizations] — never hardcoded. Phone is
/// normalized to the 11-digit Egyptian local form; the backend adds the `+2`
/// country code.
class FormValidators {
  const FormValidators(this.l10n);

  final AppLocalizations l10n;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Mirrors the backend rule (zod in `shopspace-backend`): 8-20 chars, at
  /// least one lowercase, one uppercase, one digit and one of `@$!%*?&`, and
  /// no other characters allowed.
  static final RegExp _passwordPattern = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$',
  );

  String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return l10n.authNameRequired;
    }
    return null;
  }

  String? email(String? value) {
    final String? trimmed = value?.trim();
    if (trimmed == null ||
        trimmed.isEmpty ||
        !_emailPattern.hasMatch(trimmed)) {
      return l10n.authInvalidEmail;
    }
    return null;
  }

  /// Full strength rule: 8-20 chars, ≥1 uppercase, ≥1 lowercase, ≥1 digit,
  /// ≥1 special char from `@$!%*?&` only (Q2/D4). Matches the backend zod
  /// rule exactly. Used on signup and change-password.
  String? password(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.authPasswordRequired;
    }
    if (value.length < 8) {
      return l10n.authPasswordTooShort;
    }
    if (value.length > 20) {
      return l10n.authPasswordTooLong;
    }
    if (!_passwordPattern.hasMatch(value)) {
      return l10n.authPasswordStrength;
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
    if (value == null || value.isEmpty) {
      return l10n.authInvalidPhone;
    }
    return normalizePhone(value) == null ? l10n.authInvalidPhone : null;
  }

  /// Canonicalizes digits-only input to the 11-digit Egyptian local form, or
  /// returns null when invalid. Requires an 11-digit number starting `01`,
  /// e.g. `01000000000` stays `01000000000` — the backend adds the `+2`
  /// country code (D4).
  static String? normalizePhone(String digits) {
    if (digits.length == 11 && digits.startsWith('01')) {
      return digits;
    }
    return null;
  }
}

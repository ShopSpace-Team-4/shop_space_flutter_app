import '../localization/app_localizations.dart';
import 'failures.dart';

/// Resolves the localized, user-facing message for a typed [Failure].
///
/// Extracted from [AppErrorView] so Cubits and forms can surface the exact
/// same text for failures without building the widget.
String failureMessage(AppLocalizations l10n, Failure failure) => switch (failure) {
      OfflineFailure() => l10n.errorOffline,
      TimeoutFailure() => l10n.errorTimeout,
      ServerFailure() => l10n.errorServer,
      UnauthorizedFailure() => l10n.errorUnauthorized,
      ValidationFailure() => l10n.errorValidation,
      GenericFailure() => l10n.errorGeneric,
      NetworkFailure() => l10n.errorNetwork,
      EmailAlreadyRegistered() => l10n.errorEmailAlreadyRegistered,
      PhoneAlreadyRegistered() => l10n.errorPhoneAlreadyRegistered,
      InvalidOtp() => l10n.errorInvalidOtp,
      OtpAttemptsExceeded() => l10n.errorOtpAttemptsExceeded,
      InvalidCredentials() => l10n.errorInvalidCredentials,
      EmailNotVerified() => l10n.errorEmailNotVerified,
      GoogleSignInCancelled() => l10n.errorGoogleSignInCancelled,
      RateLimited() => l10n.errorRateLimited,
    };

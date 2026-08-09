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
      ListingMetaUnavailable() => l10n.errorListingMetaUnavailable,
      ListingCreateFailed() => l10n.errorListingCreateFailed,
      ListingUpdateFailed() => l10n.errorListingUpdateFailed,
      ListingStatusFailed() => l10n.errorListingStatusFailed,
      ListingDeleteFailed() => l10n.errorListingDeleteFailed,
      ListingNotFound() => l10n.errorListingNotFound,
      MediaUploadFailed() => l10n.errorMediaUploadFailed,
      MediaReorderFailed() => l10n.errorMediaReorderFailed,
      MediaDeleteFailed() => l10n.errorMediaDeleteFailed,
      ListingNotOwned() => l10n.errorListingNotOwned,
      InvalidMediaFile() => l10n.errorInvalidMediaFile,
      PhotoLimitReached() => l10n.errorPhotoLimitReached,
      SaveListingFailed() => l10n.errorSaveListingFailed,
      UnsaveListingFailed() => l10n.errorUnsaveListingFailed,
      SavedListingsLoadFailed() => l10n.errorSavedListingsLoadFailed,
    };

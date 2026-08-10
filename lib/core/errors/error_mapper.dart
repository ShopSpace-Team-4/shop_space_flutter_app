import 'package:dio/dio.dart';

import '../network/unauthenticated_endpoints.dart';
import 'failures.dart';

/// Maps [DioException]s / non-2xx responses to typed [Failure]s carrying a
/// localized `messageKey` (contract `contracts/network-pipeline.md`; FR-005).
/// Raw exceptions never reach the UI.
class ErrorMapper {
  const ErrorMapper();

  static const String networkMessageKey = 'errorNetwork';
  static const String timeoutMessageKey = 'errorTimeout';
  static const String offlineMessageKey = 'errorOffline';
  static const String serverMessageKey = 'errorServer';
  static const String unauthorizedMessageKey = 'errorUnauthorized';
  static const String validationMessageKey = 'errorValidation';
  static const String genericMessageKey = 'errorGeneric';
  static const String emailAlreadyRegisteredMessageKey = 'errorEmailAlreadyRegistered';
  static const String phoneAlreadyRegisteredMessageKey = 'errorPhoneAlreadyRegistered';
  static const String invalidOtpMessageKey = 'errorInvalidOtp';
  static const String otpAttemptsExceededMessageKey = 'errorOtpAttemptsExceeded';
  static const String invalidCredentialsMessageKey = 'errorInvalidCredentials';
  static const String emailNotVerifiedMessageKey = 'errorEmailNotVerified';
  static const String googleSignInCancelledMessageKey = 'errorGoogleSignInCancelled';
  static const String rateLimitedMessageKey = 'errorRateLimited';
  static const String listingMetaUnavailableMessageKey = 'errorListingMetaUnavailable';
  static const String listingCreateFailedMessageKey = 'errorListingCreateFailed';
  static const String listingUpdateFailedMessageKey = 'errorListingUpdateFailed';
  static const String listingStatusFailedMessageKey = 'errorListingStatusFailed';
  static const String listingDeleteFailedMessageKey = 'errorListingDeleteFailed';
  static const String listingNotFoundMessageKey = 'errorListingNotFound';
  static const String mediaUploadFailedMessageKey = 'errorMediaUploadFailed';
  static const String mediaReorderFailedMessageKey = 'errorMediaReorderFailed';
  static const String mediaDeleteFailedMessageKey = 'errorMediaDeleteFailed';
  static const String listingNotOwnedMessageKey = 'errorListingNotOwned';
  static const String invalidMediaFileMessageKey = 'errorInvalidMediaFile';
  static const String saveListingFailedMessageKey = 'errorSaveListingFailed';
  static const String unsaveListingFailedMessageKey = 'errorUnsaveListingFailed';
  static const String savedListingsLoadFailedMessageKey =
      'errorSavedListingsLoadFailed';
  static const String linkGoogleFailedMessageKey = 'errorGoogleLinkFailed';

  static const String codeEmailAlreadyRegistered = 'email_already_registered';
  static const String codePhoneAlreadyRegistered = 'phone_already_registered';
  static const String codeInvalidOtp = 'invalid_otp';
  static const String codeOtpAttemptsExceeded = 'otp_attempts_exceeded';
  static const String codeInvalidCredentials = 'invalid_credentials';
  static const String codeEmailNotVerified = 'email_not_verified';
  static const String codeGoogleSignInCancelled = 'google_signin_cancelled';
  static const String codeRateLimited = 'rate_limited';

  /// Exception name carried by the backend error body (`error.name`) when a
  /// resource already exists (signup email, Google-account collision).
  static const String codeDuplicateResource = 'DuplicateResourceException';

  /// Exception name carried by the backend error body (`error.name`) for a
  /// generic 400; on `POST /auth/google` it signals the password-account
  /// collision (contract `contracts/google-signin-flow.md`).
  static const String codeBadRequest = 'BadRequestException';

  Failure map(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout =>
        const TimeoutFailure(timeoutMessageKey),
      DioExceptionType.connectionError => const OfflineFailure(offlineMessageKey),
      DioExceptionType.badResponse => _mapBadResponse(error),
      DioExceptionType.cancel ||
      DioExceptionType.badCertificate ||
      DioExceptionType.unknown =>
        const NetworkFailure(networkMessageKey),
    };
  }

  Failure _mapBadResponse(DioException error) {
    final Failure? authGoogleFailure = _mapAuthGoogleBadResponse(error);
    if (authGoogleFailure != null) {
      return authGoogleFailure;
    }
    final Failure? savedFailure = _mapSavedBadResponse(error);
    if (savedFailure != null) {
      return savedFailure;
    }
    final Failure? linkGoogleFailure = _mapLinkGoogleBadResponse(error);
    if (linkGoogleFailure != null) {
      return linkGoogleFailure;
    }
    final Failure? listingFailure = _mapListingBadResponse(error);
    if (listingFailure != null) {
      return listingFailure;
    }
    final int? statusCode = error.response?.statusCode;
    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      final Failure? businessFailure = _mapBusinessCode(error);
      if (businessFailure != null) {
        return businessFailure;
      }
    }
    if (statusCode == 401) {
      // Unauthenticated endpoints never signal an expired session — their 401
      // is a business rejection (bad login, unverified email, bad OTP, ...).
      if (UnauthenticatedEndpoints.contains(error.requestOptions.path)) {
        return _mapUnauthenticated401(error);
      }
      return const UnauthorizedFailure(unauthorizedMessageKey);
    }
    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      return const GenericFailure(genericMessageKey);
    }
    return const ServerFailure(serverMessageKey);
  }

  /// Maps a 401 on an unauthenticated endpoint. The backend rejects with
  /// `error.name: UnauthorizedException` and a human `message`; an unverified
  /// account mentions verification, everything else is a credentials problem.
  Failure _mapUnauthenticated401(DioException error) {
    final dynamic data = error.response?.data;
    if (data is Map) {
      final dynamic message = data['message'];
      if (message is String && message.toLowerCase().contains('verif')) {
        return const EmailNotVerified(emailNotVerifiedMessageKey);
      }
    }
    return const InvalidCredentials(invalidCredentialsMessageKey);
  }

  /// Maps the finalized saved-listings endpoints (`POST /listings/:id/save`,
  /// `DELETE /listings/:id/save`, `GET /users/me/saved-listings`, API guide §7)
  /// to their typed [Failure]s (contract `contracts/saved-listings.md`). Runs
  /// BEFORE the listing mapper so the save sub-paths are never attributed to a
  /// generic listing failure (e.g. DELETE `/listings/:id/save` is an unsave, not
  /// a listing delete). Returns `null` for anything that isn't a saved endpoint.
  Failure? _mapSavedBadResponse(DioException error) {
    final RequestOptions options = error.requestOptions;
    final String path = _SavedPaths.normalized(options.path);
    if (!_SavedPaths.isSavedPath(path)) {
      return null;
    }
    return switch (options.method) {
      'POST' => const SaveListingFailed(saveListingFailedMessageKey),
      'DELETE' => const UnsaveListingFailed(unsaveListingFailedMessageKey),
      'GET' => const SavedListingsLoadFailed(savedListingsLoadFailedMessageKey),
      _ => null,
    };
  }

  /// Maps the finalized Google sign-in endpoint (`POST /auth/google`,
  /// contract `contracts/google-signin-flow.md`) to its typed [Failure]. A
  /// password-account collision surfaces as a 4xx carrying
  /// `BadRequestException` or `DuplicateResourceException` → `EmailAlreadyRegistered`
  /// (guide the user to sign in with their password; no auto-link). Runs FIRST
  /// so the collision never falls through to a generic 4xx failure. Returns
  /// `null` for anything that isn't the google endpoint (or that must fall
  /// through to the shared pipeline).
  Failure? _mapAuthGoogleBadResponse(DioException error) {
    final RequestOptions options = error.requestOptions;
    final String path = _AuthGooglePaths.normalized(options.path);
    if (!_AuthGooglePaths.isAuthGooglePath(path)) {
      return null;
    }
    final int? statusCode = error.response?.statusCode;
    if (statusCode == null || statusCode < 400 || statusCode >= 500) {
      return null;
    }
    final dynamic data = error.response?.data;
    if (data is! Map) {
      return null;
    }
    final String? code = _businessCode(data);
    if (code != codeBadRequest && code != codeDuplicateResource) {
      return null;
    }
    return const EmailAlreadyRegistered(emailAlreadyRegisteredMessageKey);
  }

  /// Maps the finalized Google-account linking endpoint (`PATCH
  /// /users/me/link-google`, API guide §5.6, contract
  /// `contracts/google-signin-flow.md`) to its typed [Failure]. Any non-2xx on
  /// the link endpoint is a link rejection → `GoogleLinkFailed` (e.g. the
  /// Google account is already bound to another user). Runs before the generic
  /// pipeline so a link 4xx never falls through to a generic failure. Returns
  /// `null` for anything that isn't the link endpoint.
  Failure? _mapLinkGoogleBadResponse(DioException error) {
    final RequestOptions options = error.requestOptions;
    final String path = _LinkGooglePaths.normalized(options.path);
    if (!_LinkGooglePaths.isLinkGooglePath(path)) {
      return null;
    }
    final int? statusCode = error.response?.statusCode;
    if (statusCode == null || statusCode < 400 || statusCode >= 500) {
      return null;
    }
    return const GoogleLinkFailed(linkGoogleFailedMessageKey);
  }

  /// Maps `/listings*` non-2xx responses to their typed listing [Failure]
  /// (contract `contracts/listings-api.md`). Returns `null` for anything that
  /// isn't a listing endpoint (or that must fall through to the shared
  /// pipeline, e.g. `GET /listings/my-listings` and `GET /listings/:id`).
  Failure? _mapListingBadResponse(DioException error) {
    final RequestOptions options = error.requestOptions;
    final String path = _ListingPaths.normalized(options.path);
    if (!_ListingPaths.isListingPath(path)) {
      return null;
    }
    final int? statusCode = error.response?.statusCode;
    final String method = options.method;

    // GET /listings/meta: any failure means the form's options couldn't load.
    if (method == 'GET' && path == 'listings/meta') {
      return const ListingMetaUnavailable(listingMetaUnavailableMessageKey);
    }

    // GET /listings/my-listings uses the shared pipeline (bare collection).
    if (method == 'GET' && path == 'listings/my-listings') {
      return null;
    }

    // Owned-listing endpoints share the 404 and 403 semantics.
    if (statusCode == 404) {
      return const ListingNotFound(listingNotFoundMessageKey);
    }
    if (statusCode == 403) {
      return const ListingNotOwned(listingNotOwnedMessageKey);
    }

    return switch (method) {
      'POST' when path == 'listings' =>
        const ListingCreateFailed(listingCreateFailedMessageKey),
      'POST' when path.contains('/media') =>
        const MediaUploadFailed(mediaUploadFailedMessageKey),
      'PUT' when path.endsWith('/media/reorder') =>
        const MediaReorderFailed(mediaReorderFailedMessageKey),
      'PUT' => const ListingUpdateFailed(listingUpdateFailedMessageKey),
      'PATCH' when path.endsWith('/status') =>
        const ListingStatusFailed(listingStatusFailedMessageKey),
      'DELETE' when path.contains('/media') =>
        const MediaDeleteFailed(mediaDeleteFailedMessageKey),
      'DELETE' => const ListingDeleteFailed(listingDeleteFailedMessageKey),
      _ => null,
    };
  }

  /// Maps a recognized business code to its typed [Failure]. The code can be
  /// carried either by the envelope `status` field (snake_case, contract
  /// `contracts/auth-api.md`) or by the backend error body `error.name`
  /// (exception class, e.g. `DuplicateResourceException`). Returns `null` for
  /// unknown/absent codes so the status-code fallback applies.
  Failure? _mapBusinessCode(DioException error) {
    final dynamic data = error.response?.data;
    if (data is! Map) {
      return null;
    }
    final String? code = _businessCode(data);
    if (code == codeDuplicateResource) {
      return _mapDuplicateResource(data);
    }
    return switch (code) {
      codeEmailAlreadyRegistered =>
        const EmailAlreadyRegistered(emailAlreadyRegisteredMessageKey),
      codePhoneAlreadyRegistered =>
        const PhoneAlreadyRegistered(phoneAlreadyRegisteredMessageKey),
      codeInvalidOtp => const InvalidOtp(invalidOtpMessageKey),
      codeOtpAttemptsExceeded =>
        const OtpAttemptsExceeded(otpAttemptsExceededMessageKey),
      codeInvalidCredentials =>
        const InvalidCredentials(invalidCredentialsMessageKey),
      codeEmailNotVerified => const EmailNotVerified(emailNotVerifiedMessageKey),
      codeGoogleSignInCancelled =>
        const GoogleSignInCancelled(googleSignInCancelledMessageKey),
      codeRateLimited => const RateLimited(rateLimitedMessageKey),
      _ => null,
    };
  }

  /// `DuplicateResourceException` is used by the backend for any uniqueness
  /// violation (email or phone). The payload's `message` names the colliding
  /// field, so route to the matching typed [Failure] — defaulting to email when
  /// the message is absent.
  Failure _mapDuplicateResource(dynamic data) {
    final dynamic message = data['message'];
    if (message is String && message.toLowerCase().contains('phone')) {
      return const PhoneAlreadyRegistered(phoneAlreadyRegisteredMessageKey);
    }
    return const EmailAlreadyRegistered(emailAlreadyRegisteredMessageKey);
  }

  /// Resolves the business code from the response body — the envelope `status`
  /// field when present, otherwise the backend `error.name` exception name.
  String? _businessCode(dynamic data) {
    final dynamic status = data['status'];
    if (status is String && status.isNotEmpty) {
      return status;
    }
    final dynamic error = data['error'];
    if (error is Map) {
      final dynamic name = error['name'];
      if (name is String && name.isNotEmpty) {
        return name;
      }
    }
    return null;
  }
}

/// Matcher for the `/listings*` endpoint family used by [ErrorMapper].
/// Tolerates a leading slash and the `/api/v1` prefix (the base URL already
/// carries it, but retried/redirected requests may surface the full path).
abstract final class _ListingPaths {
  /// [path] must already be normalized via [normalized].
  static bool isListingPath(String path) =>
      path == 'listings' || path.startsWith('listings/');

  static String normalized(String path) {
    String normalized = path.replaceFirst(RegExp(r'^/+'), '');
    if (normalized.startsWith('api/v1/')) {
      normalized = normalized.substring('api/v1/'.length);
    }
    return normalized;
  }
}

/// Matcher for the finalized saved-listings endpoints used by [ErrorMapper]:
/// `POST /listings/:id/save`, `DELETE /listings/:id/save`, and
/// `GET /users/me/saved-listings` (API guide §7, contract `saved-listings.md`).
/// Normalization mirrors [_ListingPaths].
abstract final class _SavedPaths {
  /// [path] must already be normalized via [normalized].
  static bool isSavedPath(String path) =>
      RegExp(r'^listings/[^/]+/save$').hasMatch(path) ||
      path == 'users/me/saved-listings';

  static String normalized(String path) {
    String normalized = path.replaceFirst(RegExp(r'^/+'), '');
    if (normalized.startsWith('api/v1/')) {
      normalized = normalized.substring('api/v1/'.length);
    }
    return normalized;
  }
}

/// Matcher for the Google-account linking endpoint (`PATCH /users/me/link-google`)
/// used by [ErrorMapper] (API guide §5.6, contract `google-signin-flow.md`).
/// Normalization mirrors [_SavedPaths].
abstract final class _LinkGooglePaths {
  /// [path] must already be normalized via [normalized].
  static bool isLinkGooglePath(String path) => path == 'users/me/link-google';

  static String normalized(String path) {
    String normalized = path.replaceFirst(RegExp(r'^/+'), '');
    if (normalized.startsWith('api/v1/')) {
      normalized = normalized.substring('api/v1/'.length);
    }
    return normalized;
  }
}

/// Matcher for the Google sign-in endpoint (`POST /auth/google`) used by
/// [ErrorMapper]. Normalization mirrors [_SavedPaths].
abstract final class _AuthGooglePaths {
  /// [path] must already be normalized via [normalized].
  static bool isAuthGooglePath(String path) => path == 'auth/google';

  static String normalized(String path) {
    String normalized = path.replaceFirst(RegExp(r'^/+'), '');
    if (normalized.startsWith('api/v1/')) {
      normalized = normalized.substring('api/v1/'.length);
    }
    return normalized;
  }
}

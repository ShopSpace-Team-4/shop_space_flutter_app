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

import 'package:dio/dio.dart';

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
  static const String emailAlreadyRegisteredMessageKey = 'errorEmailAlreadyRegistered';
  static const String invalidOtpMessageKey = 'errorInvalidOtp';
  static const String otpAttemptsExceededMessageKey = 'errorOtpAttemptsExceeded';
  static const String invalidCredentialsMessageKey = 'errorInvalidCredentials';
  static const String emailNotVerifiedMessageKey = 'errorEmailNotVerified';
  static const String googleSignInCancelledMessageKey = 'errorGoogleSignInCancelled';
  static const String rateLimitedMessageKey = 'errorRateLimited';

  static const String codeEmailAlreadyRegistered = 'email_already_registered';
  static const String codeInvalidOtp = 'invalid_otp';
  static const String codeOtpAttemptsExceeded = 'otp_attempts_exceeded';
  static const String codeInvalidCredentials = 'invalid_credentials';
  static const String codeEmailNotVerified = 'email_not_verified';
  static const String codeGoogleSignInCancelled = 'google_signin_cancelled';
  static const String codeRateLimited = 'rate_limited';

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
      return const UnauthorizedFailure(unauthorizedMessageKey);
    }
    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      return const ValidationFailure(validationMessageKey);
    }
    return const ServerFailure(serverMessageKey);
  }

  /// Maps a recognized business code carried by the envelope `status` field
  /// (snake_case, contract `contracts/auth-api.md`) to its typed [Failure].
  /// Returns `null` for unknown/absent codes so the status-code fallback applies.
  Failure? _mapBusinessCode(DioException error) {
    final dynamic data = error.response?.data;
    if (data is! Map) {
      return null;
    }
    final String code = data['status'] as String? ?? '';
    return switch (code) {
      codeEmailAlreadyRegistered =>
        const EmailAlreadyRegistered(emailAlreadyRegisteredMessageKey),
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
}

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
    if (statusCode == 401) {
      return const UnauthorizedFailure(unauthorizedMessageKey);
    }
    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      return const ValidationFailure(validationMessageKey);
    }
    return const ServerFailure(serverMessageKey);
  }
}

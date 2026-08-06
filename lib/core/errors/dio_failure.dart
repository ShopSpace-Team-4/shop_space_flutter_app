import 'package:dio/dio.dart';

import 'error_mapper.dart';
import 'failures.dart';

/// Unwraps the typed [Failure] the pipeline attached to a [DioException]
/// (`lib/core/network/interceptors/error_interceptor.dart`), so features only
/// ever surface typed failures. Falls back to [NetworkFailure] when the error
/// bypassed the pipeline.
extension DioFailureX on DioException {
  Failure get failure {
    final Object? typed = error;
    return typed is Failure
        ? typed
        : const NetworkFailure(ErrorMapper.networkMessageKey);
  }
}

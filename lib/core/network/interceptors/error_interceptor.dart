import 'package:dio/dio.dart';

import '../../errors/error_mapper.dart';
import '../../errors/failures.dart';

/// Routes every error through [ErrorMapper] so only typed [Failure]s
/// propagate to the UI (contract `contracts/network-pipeline.md`; FR-005).
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this._mapper);

  final ErrorMapper _mapper;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final Failure failure = _mapper.map(err);
    handler.reject(err.copyWith(error: failure), true);
  }
}

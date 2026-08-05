import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../env/app_env.dart';

/// Plain debug-print logging for development builds only, gated by
/// [AppEnv.isLoggingEnabled] (dev/staging on, prod off).
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._env);

  final AppEnv _env;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_env.isLoggingEnabled) {
      debugPrint('--> ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (_env.isLoggingEnabled) {
      debugPrint('<-- ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_env.isLoggingEnabled) {
      debugPrint(
        '<-- ${err.response?.statusCode} ${err.type} ${err.requestOptions.uri}',
      );
    }
    handler.next(err);
  }
}

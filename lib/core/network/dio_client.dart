import 'package:dio/dio.dart';

import '../env/app_env.dart';
import '../errors/error_mapper.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/envelope_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/session_interceptor.dart';
import 'session_controller.dart';
import 'token_provider.dart';
import 'token_refresher.dart';

/// Factory building the app's [Dio] with the shared pipeline registered in
/// order: auth → envelope → session/refresh → error → logging
/// (contract `contracts/network-pipeline.md` §Interceptor order).
abstract class DioClient {
  static const String apiPrefix = '/api/v1';

  static const Duration _timeout = Duration(seconds: 5);

  static Dio create({
    required AppEnv env,
    required TokenProvider tokenProvider,
    required TokenRefresher tokenRefresher,
    required SessionController session,
    required ErrorMapper errorMapper,
  }) {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: '${env.apiBaseUrl}$apiPrefix',
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        sendTimeout: _timeout,
        responseType: ResponseType.json,
      ),
    );
    final SessionInterceptor sessionInterceptor = SessionInterceptor(
      refresher: tokenRefresher,
      session: session,
    );
    dio.interceptors
      ..add(AuthInterceptor(tokenProvider))
      ..add(const EnvelopeInterceptor())
      ..add(sessionInterceptor)
      ..add(ErrorInterceptor(errorMapper))
      ..add(LoggingInterceptor(env));
    sessionInterceptor.attachDio(dio);
    return dio;
  }
}

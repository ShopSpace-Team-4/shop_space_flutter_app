import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../env/app_env.dart';
import '../errors/error_mapper.dart';
import '../network/dio_client.dart';
import '../network/session_controller.dart';
import '../network/token_provider.dart';
import '../network/token_refresher.dart';
import '../storage/preferences_service.dart';
import '../storage/token_storage.dart';

@module
abstract class CoreModule {
  @singleton
  AppEnv get appEnv => AppEnv.fromDartDefine();

  @singleton
  TokenStorage get tokenStorage => SecureTokenStorage();

  @singleton
  PreferencesService get preferencesService => SharedPreferencesService();

  @singleton
  ErrorMapper get errorMapper => const ErrorMapper();

  @singleton
  TokenProvider tokenProvider(TokenStorage storage) =>
      SecureTokenProvider(storage);

  @singleton
  SessionController sessionController(TokenStorage storage) =>
      SessionController(storage);

  @singleton
  TokenRefresher tokenRefresher(
    AppEnv env,
    TokenStorage storage,
  ) =>
      TokenRefresher(env: env, storage: storage);

  @singleton
  Dio dio(
    AppEnv env,
    TokenProvider tokenProvider,
    TokenRefresher tokenRefresher,
    SessionController session,
    ErrorMapper errorMapper,
  ) =>
      DioClient.create(
        env: env,
        tokenProvider: tokenProvider,
        tokenRefresher: tokenRefresher,
        session: session,
        errorMapper: errorMapper,
      );
}

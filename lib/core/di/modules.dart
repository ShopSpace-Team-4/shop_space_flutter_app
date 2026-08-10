import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/data/auth_datasource.dart';
import '../../features/auth/data/models/auth_tokens.dart' as feature;
import '../../features/auth/data/models/refresh_token_request.dart';
import '../../features/auth/presentation/cubits/auth_session_cubit.dart';
import '../env/app_env.dart';
import '../errors/error_mapper.dart';
import '../network/dio_client.dart';
import '../network/session_controller.dart';
import '../network/token_provider.dart';
import '../network/token_refresher.dart';
import '../router/app_router.dart';
import '../router/route_guards.dart';
import '../storage/preferences_service.dart';
import '../storage/token_storage.dart';

@module
abstract class CoreModule {
  @singleton
  AppEnv get appEnv => AppEnv.fromEnv();

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
  TokenRefresher tokenRefresher(TokenStorage storage) => TokenRefresher(
        storage: storage,
        refreshTokens: (AuthTokens current) async {
          final feature.AuthTokens refreshed = await GetIt.instance
              .get<AuthDataSource>()
              .refreshToken(
                RefreshTokenRequest(refreshToken: current.refreshToken),
              );
          return AuthTokens(
            accessToken: refreshed.accessToken,
            refreshToken: refreshed.refreshToken,
          );
        },
      );

  // Router owns the initialized session (T021): bootstrap awaits
  // `session.initialize()` before `runApp`, so guards assume it is resolved.
  @singleton
  AppRouter provideAppRouter(AuthSessionCubit session) =>
      AppRouter(session: session);

  // The session cubit registers as `SessionReader`; alias the concrete key so
  // `getIt<AuthSessionCubit>()` resolves to the same instance (bootstrap,
  // login screen, etc.).
  @singleton
  AuthSessionCubit provideAuthSessionCubit(SessionReader reader) =>
      reader as AuthSessionCubit;

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

import 'package:dio/dio.dart';

import '../env/app_env.dart';
import '../storage/token_storage.dart';
import 'envelope.dart';

/// Refreshes the token pair through a separate BARE [Dio] — no interceptors —
/// so a refresh triggered from inside the session interceptor never recurses
/// into itself (contract `contracts/network-pipeline.md`).
///
/// Returns the new pair on success; the caller ([SessionInterceptor]) persists
/// it via the session controller (FR-007).
class TokenRefresher {
  TokenRefresher({
    required AppEnv env,
    required TokenStorage storage,
  })  : _env = env,
        _storage = storage;

  static const Duration _timeout = Duration(seconds: 5);

  final AppEnv _env;
  final TokenStorage _storage;

  /// Returns the refreshed token pair, or `null` when there is no refresh
  /// token or the refresh call fails.
  Future<AuthTokens?> refresh() async {
    final AuthTokens? current = await _storage.read();
    if (current == null) {
      return null;
    }
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: '${_env.apiBaseUrl}/api/v1',
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        sendTimeout: _timeout,
      ),
    );
    try {
      final Response<dynamic> response = await dio.post<dynamic>(
        '/auth/refresh',
        data: {'refreshToken': current.refreshToken},
      );
      final ApiEnvelope<dynamic> envelope = ApiEnvelope.fromJson(
        response.data as Map<String, dynamic>,
      );
      final Map<String, dynamic> data = envelope.data as Map<String, dynamic>;
      final AuthTokens refreshed = AuthTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      return refreshed;
    } on DioException {
      return null;
    } finally {
      dio.close();
    }
  }
}

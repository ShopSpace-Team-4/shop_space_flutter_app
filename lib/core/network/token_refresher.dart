import '../errors/failures.dart';
import '../storage/token_storage.dart';

/// Refreshes the token pair through [AuthDataSource.refreshToken] — the single
/// source for `POST /auth/refresh-token` (contract `contracts/auth-api.md`).
///
/// The network call is delegated to [refreshTokens] so the DI layer can resolve
/// the data source lazily, avoiding a construction cycle: `AuthDataSource`
/// needs the shared `Dio`, and building that `Dio` needs this refresher.
///
/// Returns the new pair on success, or `null` when there is no refresh token
/// or the refresh call fails. The caller ([SessionInterceptor]) persists the
/// pair via the session controller (FR-007).
class TokenRefresher {
  TokenRefresher({
    required TokenStorage storage,
    required Future<AuthTokens?> Function(AuthTokens current) refreshTokens,
  })  : _storage = storage,
        _refreshTokens = refreshTokens;

  final TokenStorage _storage;
  final Future<AuthTokens?> Function(AuthTokens current) _refreshTokens;

  Future<AuthTokens?> refresh() async {
    final AuthTokens? current = await _storage.read();
    if (current == null) {
      return null;
    }
    try {
      return await _refreshTokens(current);
    } on Failure {
      return null;
    } catch (_) {
      return null;
    }
  }
}

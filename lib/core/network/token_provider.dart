import '../storage/token_storage.dart';

/// Supplies the current access token to the auth interceptor.
///
/// Registered in DI (`lib/core/di/modules.dart`) so tests swap mocks.
abstract class TokenProvider {
  Future<String?> accessToken();
}

/// Default [TokenProvider] backed by [TokenStorage].
class SecureTokenProvider implements TokenProvider {
  SecureTokenProvider(this._storage);

  final TokenStorage _storage;

  @override
  Future<String?> accessToken() async {
    final AuthTokens? tokens = await _storage.read();
    return tokens?.accessToken;
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/auth_tokens.dart';

export '../../features/auth/data/models/auth_tokens.dart';

abstract class TokenStorage {
  Future<AuthTokens?> read();
  Future<void> write(AuthTokens tokens);
  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(storageNamespace: 'shop_space'),
          iOptions: IOSOptions(accountName: 'com.shopspace.shopspace'),
        );

  static const String _accessTokenKey = 'auth.accessToken';
  static const String _refreshTokenKey = 'auth.refreshToken';

  final FlutterSecureStorage _storage;

  @override
  Future<AuthTokens?> read() async {
    final String? accessToken = await _storage.read(key: _accessTokenKey);
    final String? refreshToken = await _storage.read(key: _refreshTokenKey);
    if (accessToken == null || refreshToken == null) {
      return null;
    }
    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  @override
  Future<void> write(AuthTokens tokens) async {
    await _storage.write(key: _refreshTokenKey, value: tokens.refreshToken);
    await _storage.write(key: _accessTokenKey, value: tokens.accessToken);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}

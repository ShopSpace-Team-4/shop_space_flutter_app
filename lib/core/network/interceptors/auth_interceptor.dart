import 'package:dio/dio.dart';

import '../token_provider.dart';

/// Attaches `Authorization: Bearer <accessToken>` (from [TokenProvider]) to
/// protected requests. Auth endpoints on the denylist never carry the header
/// (contract `contracts/network-pipeline.md`).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenProvider);

  static const List<String> _denylist = [
    'auth/login',
    'auth/signup',
    'auth/refresh-token',
    'auth/verify',
    'auth/resend-otp',
    'auth/forgot-password',
    'auth/reset-password',
    'auth/google',
  ];

  final TokenProvider _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isDenied(options.path)) {
      handler.next(options);
      return;
    }
    final String? token = await _tokenProvider.accessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  bool _isDenied(String path) {
    final String normalized = path.replaceFirst(RegExp(r'^/+'), '');
    return _denylist.any(
      (String entry) =>
          normalized == entry || normalized.startsWith('$entry/'),
    );
  }
}

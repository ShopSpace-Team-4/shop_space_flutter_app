import 'package:dio/dio.dart';

import '../token_provider.dart';
import '../unauthenticated_endpoints.dart';

/// Attaches `Authorization: Bearer <accessToken>` (from [TokenProvider]) to
/// protected requests. Auth endpoints on the denylist never carry the header
/// (contract `contracts/network-pipeline.md`).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenProvider);

  final TokenProvider _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (UnauthenticatedEndpoints.contains(options.path)) {
      handler.next(options);
      return;
    }
    final String? token = await _tokenProvider.accessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

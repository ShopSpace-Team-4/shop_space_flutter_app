import 'package:dio/dio.dart';

import '../envelope.dart';

/// Unwraps the `{ message, status, data }` envelope exactly once on success
/// (contract `contracts/network-pipeline.md`). Non-2xx responses are handled in
/// the error path and never reach here.
class EnvelopeInterceptor extends Interceptor {
  const EnvelopeInterceptor();

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final dynamic data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      response.data = ApiEnvelope<dynamic>.fromJson(data).data;
    }
    handler.next(response);
  }
}

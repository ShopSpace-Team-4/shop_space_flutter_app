import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shop_space/core/network/interceptors/auth_interceptor.dart';
import 'package:shop_space/core/network/token_provider.dart';

class MockTokenProvider extends Mock implements TokenProvider {}

class CapturingAdapter implements HttpClientAdapter {
  CapturingAdapter(this.captured);

  final Map<String, Map<String, dynamic>> captured;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured[options.path] = Map<String, dynamic>.from(options.headers);
    return ResponseBody.fromString(
      jsonEncode(<String, dynamic>{
        'message': 'ok',
        'status': 'success',
        'data': <String, dynamic>{},
      }),
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('AuthInterceptor', () {
    const timeout = Duration(seconds: 5);

    late MockTokenProvider tokenProvider;
    late Map<String, Map<String, dynamic>> captured;
    late Dio dio;

    setUp(() {
      tokenProvider = MockTokenProvider();
      captured = <String, Map<String, dynamic>>{};
      dio = Dio(
        BaseOptions(
          baseUrl: 'http://localhost:3000',
          connectTimeout: timeout,
          receiveTimeout: timeout,
          sendTimeout: timeout,
        ),
      )
        ..httpClientAdapter = CapturingAdapter(captured)
        ..interceptors.add(AuthInterceptor(tokenProvider));
    });

    test('attaches bearer token to protected requests', () async {
      when(() => tokenProvider.accessToken()).thenAnswer((_) async => 't0ken');

      await dio.get<dynamic>('/users/me');

      expect(captured['/users/me']!['Authorization'], 'Bearer t0ken');
      verify(() => tokenProvider.accessToken()).called(1);
    });

    test('leaves the request untouched when there is no token', () async {
      when(() => tokenProvider.accessToken()).thenAnswer((_) async => null);

      await dio.get<dynamic>('/users/me');

      expect(captured['/users/me']!['Authorization'], isNull);
    });

    test('skips denylisted auth endpoints', () async {
      for (final path in [
        '/auth/login',
        '/auth/signup',
        '/auth/refresh-token',
        '/auth/verify',
        '/auth/resend-otp',
        '/auth/forgot-password',
        '/auth/reset-password',
        '/auth/google',
      ]) {
        await dio.get<dynamic>(path);
      }

      for (final path in captured.keys) {
        expect(captured[path]!['Authorization'], isNull, reason: path);
      }
      verifyNever(() => tokenProvider.accessToken());
    });

    test('matches denylist entries for nested paths', () async {
      await dio.get<dynamic>('/auth/reset-password/confirm');

      expect(captured['/auth/reset-password/confirm']!['Authorization'],
          isNull);
      verifyNever(() => tokenProvider.accessToken());
    });
  });
}

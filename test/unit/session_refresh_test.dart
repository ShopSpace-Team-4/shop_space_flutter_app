import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shop_space/core/network/interceptors/session_interceptor.dart';
import 'package:shop_space/core/network/session_controller.dart';
import 'package:shop_space/core/network/token_refresher.dart';
import 'package:shop_space/core/storage/token_storage.dart';

class MockTokenRefresher extends Mock implements TokenRefresher {}

class MockSessionController extends Mock implements SessionController {}

class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.onFetch);

  Future<ResponseBody> Function(RequestOptions options) onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) =>
      onFetch(options);

  @override
  void close({bool force = false}) {}
}

const _jsonHeaders = <String, List<String>>{
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

ResponseBody _jsonBody(String body, int statusCode) =>
    ResponseBody.fromString(body, statusCode, headers: _jsonHeaders);

ResponseBody _okEnvelope() => _jsonBody(
      jsonEncode(<String, dynamic>{
        'message': 'ok',
        'status': 'success',
        'data': <String, dynamic>{
          'accessToken': 'new-access',
          'refreshToken': 'new-refresh',
        },
      }),
      200,
    );

ResponseBody _unauthorized() => _jsonBody(
      jsonEncode(<String, dynamic>{
        'message': 'unauthorized',
        'status': 'error',
        'data': null,
      }),
      401,
    );

const _tokens = AuthTokens(accessToken: 'new-access', refreshToken: 'new-refresh');

void main() {
  group('SessionInterceptor', () {
    const timeout = Duration(seconds: 5);

    late MockTokenRefresher refresher;
    late MockSessionController session;

    setUpAll(() {
      registerFallbackValue(
        const AuthTokens(accessToken: 'fallback', refreshToken: 'fallback'),
      );
    });

    setUp(() {
      refresher = MockTokenRefresher();
      session = MockSessionController();
    });

    Dio buildDio(FakeAdapter adapter) {
      final dio = Dio(
        BaseOptions(
          baseUrl: 'http://localhost:3000',
          connectTimeout: timeout,
          receiveTimeout: timeout,
          sendTimeout: timeout,
        ),
      )..httpClientAdapter = adapter;
      final interceptor = SessionInterceptor(
        refresher: refresher,
        session: session,
      );
      dio.interceptors.add(interceptor);
      interceptor.attachDio(dio);
      return dio;
    }

    test('refreshes once and retries the original request on 401', () async {
      when(() => refresher.refresh()).thenAnswer((_) async => _tokens);
      when(() => session.onTokensUpdated(any())).thenAnswer((_) async {});
      var callCount = 0;
      final dio = buildDio(
        FakeAdapter(
          (options) async {
            callCount += 1;
            return callCount == 1 ? _unauthorized() : _okEnvelope();
          },
        ),
      );

      final stopwatch = Stopwatch()..start();
      final response =
          await dio.get<dynamic>('/users/me').timeout(timeout);
      stopwatch.stop();

      expect(response.statusCode, 200);
      expect(stopwatch.elapsed, lessThan(timeout));
      verify(() => refresher.refresh()).called(1);
      verify(() => session.onTokensUpdated(_tokens)).called(1);
    });

    test('concurrent 401s share a single refresh', () async {
      when(() => refresher.refresh()).thenAnswer((_) async => _tokens);
      when(() => session.onTokensUpdated(any())).thenAnswer((_) async {});
      var callCount = 0;
      final dio = buildDio(
        FakeAdapter(
          (options) async {
            callCount += 1;
            return callCount <= 2 ? _unauthorized() : _okEnvelope();
          },
        ),
      );

      await Future.wait<void>([
        dio.get<dynamic>('/a'),
        dio.get<dynamic>('/b'),
      ]);

      verify(() => refresher.refresh()).called(1);
    });

    test('failed refresh clears the session and signals expiration', () async {
      when(() => refresher.refresh()).thenAnswer((_) async => null);
      when(() => session.onSessionExpired()).thenAnswer((_) async {});
      final dio = buildDio(FakeAdapter((options) async => _unauthorized()));

      await expectLater(
        dio.get<dynamic>('/users/me').timeout(timeout),
        throwsA(isA<DioException>()),
      );

      verify(() => session.onSessionExpired()).called(1);
      verifyNever(() => session.onTokensUpdated(any()));
    });

    test('a second 401 on the retried request force-logs-out without retrying',
        () async {
      when(() => refresher.refresh()).thenAnswer((_) async => _tokens);
      when(() => session.onTokensUpdated(any())).thenAnswer((_) async {});
      when(() => session.onSessionExpired()).thenAnswer((_) async {});
      final dio = buildDio(FakeAdapter((options) async => _unauthorized()));

      await expectLater(
        dio.get<dynamic>('/users/me').timeout(timeout),
        throwsA(isA<DioException>()),
      );

      verify(() => refresher.refresh()).called(1);
      verify(() => session.onSessionExpired()).called(1);
    });

    test('non-401 errors pass through untouched', () async {
      final dio = buildDio(
        FakeAdapter(
          (options) async => _jsonBody(
            jsonEncode(<String, dynamic>{
              'message': 'forbidden',
              'status': 'error',
              'data': null,
            }),
            403,
          ),
        ),
      );

      await expectLater(
        dio.get<dynamic>('/users/me').timeout(timeout),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            403,
          ),
        ),
      );

      verifyNever(() => refresher.refresh());
      verifyNever(() => session.onSessionExpired());
    });

    test('a 401 on the refresh endpoint never triggers another refresh',
        () async {
      final dio = buildDio(FakeAdapter((options) async => _unauthorized()));

      await expectLater(
        dio.get<dynamic>('/auth/refresh-token').timeout(timeout),
        throwsA(isA<DioException>()),
      );

      verifyNever(() => refresher.refresh());
      verifyNever(() => session.onSessionExpired());
    });
  });
}

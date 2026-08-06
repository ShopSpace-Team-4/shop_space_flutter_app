import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/core/errors/error_mapper.dart';
import 'package:shop_space/core/errors/failures.dart';
import 'package:shop_space/core/network/interceptors/envelope_interceptor.dart';
import 'package:shop_space/core/network/interceptors/error_interceptor.dart';
import 'package:shop_space/features/auth/data/auth_datasource.dart';
import 'package:shop_space/features/auth/data/models/auth_tokens.dart';
import 'package:shop_space/features/auth/data/models/forgot_password_request.dart';
import 'package:shop_space/features/auth/data/models/google_signin_request.dart';
import 'package:shop_space/features/auth/data/models/login_request.dart';
import 'package:shop_space/features/auth/data/models/otp_verification_request.dart';
import 'package:shop_space/features/auth/data/models/refresh_token_request.dart';
import 'package:shop_space/features/auth/data/models/resend_otp_request.dart';
import 'package:shop_space/features/auth/data/models/reset_password_request.dart';
import 'package:shop_space/features/auth/data/models/signup_request.dart';

class RecordingAdapter implements HttpClientAdapter {
  RecordingAdapter({this.onFetch});

  final List<RequestOptions> requests = <RequestOptions>[];
  Future<ResponseBody> Function(RequestOptions)? onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (onFetch != null) {
      return onFetch!(options);
    }
    return _emptyEnvelope;
  }

  @override
  void close({bool force = false}) {}
}

const _jsonHeaders = <String, List<String>>{
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

ResponseBody _body(String payload, int statusCode) =>
    ResponseBody.fromString(payload, statusCode, headers: _jsonHeaders);

ResponseBody get _emptyEnvelope => _body(
      jsonEncode(<String, dynamic>{
        'message': 'ok',
        'status': 'success',
        'data': <String, dynamic>{},
      }),
      200,
    );

ResponseBody _tokensEnvelope() => _body(
      jsonEncode(<String, dynamic>{
        'message': 'ok',
        'status': 'success',
        'data': <String, dynamic>{
          'accessToken': 'access-1',
          'refreshToken': 'refresh-1',
        },
      }),
      200,
    );

ResponseBody _otpDeliveredEnvelope() => _body(
      jsonEncode(<String, dynamic>{
        'message': 'ok',
        'status': 'success',
        'data': <String, dynamic>{'otpDelivered': true},
      }),
      200,
    );

ResponseBody _errorEnvelope(String status, int code) => _body(
      jsonEncode(<String, dynamic>{
        'message': 'nope',
        'status': status,
        'data': null,
      }),
      code,
    );

Dio _dio(RecordingAdapter adapter) => Dio(
      BaseOptions(
        baseUrl: 'http://localhost:3000/api/v1',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ),
    )
      ..httpClientAdapter = adapter
      ..interceptors.addAll(<Interceptor>[
        const EnvelopeInterceptor(),
        ErrorInterceptor(const ErrorMapper()),
      ]);

Map<String, dynamic> _bodyOf(RequestOptions options) {
  final Object? data = options.data;
  if (data is Map<String, dynamic>) {
    return data;
  }
  return jsonDecode(data as String) as Map<String, dynamic>;
}

void main() {
  group('AuthDataSourceImpl', () {
    late RecordingAdapter adapter;
    late AuthDataSourceImpl dataSource;

    setUp(() {
      adapter = RecordingAdapter();
      dataSource = AuthDataSourceImpl(_dio(adapter));
    });

    const SignupRequest signupRequest = SignupRequest(
      firstName: 'Omar',
      lastName: 'Hassan',
      email: 'omar@example.com',
      phone: '+201000000000',
      password: 'pass1234',
    );

    test('signup posts to /auth/signup with the request body', () async {
      await dataSource.signup(signupRequest);

      final RequestOptions options = adapter.requests.single;
      expect(options.method, 'POST');
      expect(options.path, '/auth/signup');
      expect(_bodyOf(options), signupRequest.toJson());
    });

    test('login posts to /auth/login and returns AuthTokens', () async {
      adapter.onFetch = (_) async => _tokensEnvelope();

      const LoginRequest request =
          LoginRequest(email: 'omar@example.com', password: 'pass1234');
      final AuthTokens tokens = await dataSource.login(request);

      final RequestOptions options = adapter.requests.single;
      expect(options.path, '/auth/login');
      expect(_bodyOf(options), request.toJson());
      expect(tokens.accessToken, 'access-1');
      expect(tokens.refreshToken, 'refresh-1');
    });

    test('googleSignIn posts the idToken and returns AuthTokens', () async {
      adapter.onFetch = (_) async => _tokensEnvelope();

      final AuthTokens tokens = await dataSource.googleSignIn(
        const GoogleSignInRequest(idToken: 'id-token'),
      );

      final RequestOptions options = adapter.requests.single;
      expect(options.path, '/auth/google');
      expect(_bodyOf(options), <String, dynamic>{'idToken': 'id-token'});
      expect(tokens.accessToken, 'access-1');
    });

    test('verifyOtp posts to /auth/verify with email and code', () async {
      await dataSource.verifyOtp(
        const OtpVerificationRequest(email: 'omar@example.com', otpCode: '123456'),
      );

      final RequestOptions options = adapter.requests.single;
      expect(options.path, '/auth/verify');
      expect(
        _bodyOf(options),
        <String, dynamic>{'email': 'omar@example.com', 'otpCode': '123456'},
      );
    });

    test('resendOtp reads data.otpDelivered', () async {
      adapter.onFetch = (_) async => _otpDeliveredEnvelope();

      final bool delivered =
          await dataSource.resendOtp(const ResendOtpRequest(email: 'omar@example.com'));

      expect(adapter.requests.single.path, '/auth/resend-otp');
      expect(delivered, isTrue);
    });

    test('logout posts to /auth/logout best-effort and swallows errors', () async {
      adapter.onFetch = (_) async => _errorEnvelope('server_error', 500);

      await dataSource.logout();

      expect(adapter.requests.single.path, '/auth/logout');
    });

    test('refreshToken posts to /auth/refresh-token and returns AuthTokens',
        () async {
      adapter.onFetch = (_) async => _tokensEnvelope();

      final AuthTokens tokens = await dataSource.refreshToken(
        const RefreshTokenRequest(refreshToken: 'refresh-1'),
      );

      final RequestOptions options = adapter.requests.single;
      expect(options.path, '/auth/refresh-token');
      expect(_bodyOf(options), <String, dynamic>{'refreshToken': 'refresh-1'});
      expect(tokens.accessToken, 'access-1');
    });

    test('forgotPassword posts to /auth/forgot-password', () async {
      await dataSource.forgotPassword(
        const ForgotPasswordRequest(email: 'omar@example.com'),
      );

      final RequestOptions options = adapter.requests.single;
      expect(options.path, '/auth/forgot-password');
      expect(_bodyOf(options), <String, dynamic>{'email': 'omar@example.com'});
    });

    test('resetPassword posts to /auth/reset-password', () async {
      await dataSource.resetPassword(
        const ResetPasswordRequest(
          email: 'omar@example.com',
          otpCode: '123456',
          newPassword: 'newpass123',
        ),
      );

      final RequestOptions options = adapter.requests.single;
      expect(options.path, '/auth/reset-password');
      expect(_bodyOf(options), <String, dynamic>{
        'email': 'omar@example.com',
        'otpCode': '123456',
        'newPassword': 'newpass123',
      });
    });

    group('failure mapping', () {
      test('login invalid_credentials -> InvalidCredentials', () {
        adapter.onFetch =
            (_) async => _errorEnvelope(ErrorMapper.codeInvalidCredentials, 401);

        expect(
          dataSource.login(const LoginRequest(email: 'a@b.com', password: 'x')),
          throwsA(isA<InvalidCredentials>()),
        );
      });

      test('login email_not_verified -> EmailNotVerified', () {
        adapter.onFetch =
            (_) async => _errorEnvelope(ErrorMapper.codeEmailNotVerified, 403);

        expect(
          dataSource.login(
            const LoginRequest(email: 'a@b.com', password: 'pass1234'),
          ),
          throwsA(isA<EmailNotVerified>()),
        );
      });

      test('signup email_already_registered -> EmailAlreadyRegistered', () {
        adapter.onFetch = (_) async =>
            _errorEnvelope(ErrorMapper.codeEmailAlreadyRegistered, 409);

        expect(
          dataSource.signup(signupRequest),
          throwsA(isA<EmailAlreadyRegistered>()),
        );
      });

      test('verifyOtp invalid_otp -> InvalidOtp', () {
        adapter.onFetch = (_) async =>
            _errorEnvelope(ErrorMapper.codeInvalidOtp, 400);

        expect(
          dataSource.verifyOtp(
            const OtpVerificationRequest(email: 'a@b.com', otpCode: '000000'),
          ),
          throwsA(isA<InvalidOtp>()),
        );
      });

      test('verifyOtp otp_attempts_exceeded -> OtpAttemptsExceeded', () {
        adapter.onFetch =
            (_) async => _errorEnvelope(ErrorMapper.codeOtpAttemptsExceeded, 429);

        expect(
          dataSource.verifyOtp(
            const OtpVerificationRequest(email: 'a@b.com', otpCode: '000000'),
          ),
          throwsA(isA<OtpAttemptsExceeded>()),
        );
      });

      test('resendOtp rate_limited -> RateLimited', () {
        adapter.onFetch =
            (_) async => _errorEnvelope(ErrorMapper.codeRateLimited, 429);

        expect(
          dataSource.resendOtp(const ResendOtpRequest(email: 'a@b.com')),
          throwsA(isA<RateLimited>()),
        );
      });
    });
  });
}

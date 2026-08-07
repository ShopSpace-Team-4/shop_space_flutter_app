import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/dio_failure.dart';
import 'models/auth_tokens.dart';
import 'models/forgot_password_request.dart';
import 'models/google_signin_request.dart';
import 'models/login_request.dart';
import 'models/otp_verification_request.dart';
import 'models/refresh_token_request.dart';
import 'models/resend_otp_request.dart';
import 'models/reset_password_request.dart';
import 'models/signup_request.dart';

/// Raw network surface for the auth endpoints
/// (`specs/002-auth-verification-roles/contracts/auth-api.md`). Methods throw
/// typed [Failure]s only — never raw [DioException]s.
abstract class AuthDataSource {
  Future<void> signup(SignupRequest request);

  Future<AuthTokens> login(LoginRequest request);

  Future<AuthTokens> googleSignIn(GoogleSignInRequest request);

  Future<void> verifyOtp(OtpVerificationRequest request);

  Future<void> resendOtp(ResendOtpRequest request);

  Future<void> logout();

  Future<AuthTokens> refreshToken(RefreshTokenRequest request);

  Future<void> forgotPassword(ForgotPasswordRequest request);

  Future<void> resetPassword(ResetPasswordRequest request);
}

@Injectable(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> signup(SignupRequest request) => _request<void>(
        () => _dio.post<dynamic>('/auth/signup', data: request.toJson()),
      );

  @override
  Future<AuthTokens> login(LoginRequest request) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.post<dynamic>('/auth/login', data: request.toJson()),
    );
    return AuthTokens.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthTokens> googleSignIn(GoogleSignInRequest request) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.post<dynamic>('/auth/google', data: request.toJson()),
    );
    return AuthTokens.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> verifyOtp(OtpVerificationRequest request) => _request<void>(
        () => _dio.post<dynamic>('/auth/verify', data: request.toJson()),
      );

  @override
  Future<void> resendOtp(ResendOtpRequest request) => _request<void>(
        () => _dio.post<dynamic>('/auth/resend-otp', data: request.toJson()),
      );

  @override
  Future<void> logout() async {
    try {
      await _dio.post<dynamic>('/auth/logout');
    } on DioException {
      // Best-effort: the local session is cleared regardless of network result.
    }
  }

  @override
  Future<AuthTokens> refreshToken(RefreshTokenRequest request) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.post<dynamic>('/auth/refresh-token', data: request.toJson()),
    );
    return AuthTokens.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequest request) =>
      _request<void>(
        () => _dio.post<dynamic>('/auth/forgot-password', data: request.toJson()),
      );

  @override
  Future<void> resetPassword(ResetPasswordRequest request) => _request<void>(
        () => _dio.post<dynamic>('/auth/reset-password', data: request.toJson()),
      );

  /// Runs [call] and rethrows the typed [Failure] the pipeline attached to any
  /// [DioException] (see `lib/core/errors/dio_failure.dart`).
  Future<T> _request<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (error) {
      throw error.failure;
    }
  }
}

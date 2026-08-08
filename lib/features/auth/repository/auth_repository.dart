import 'package:injectable/injectable.dart';

import '../data/auth_datasource.dart';
import '../data/models/auth_tokens.dart';
import '../data/models/forgot_password_request.dart';
import '../data/models/google_signin_request.dart';
import '../data/models/login_request.dart';
import '../data/models/otp_verification_request.dart';
import '../data/models/refresh_token_request.dart';
import '../data/models/resend_otp_request.dart';
import '../data/models/reset_password_request.dart';
import '../data/models/signup_request.dart';

/// Application use-case surface for unauthenticated auth flows and the token
/// lifecycle (contract `contracts/auth-api.md`). A repository interface method
/// IS the use case (constitution §Architecture). Methods surface only typed
/// failures — never raw exceptions (guaranteed by [AuthDataSource]).
abstract class AuthRepository {
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

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthDataSource _dataSource;

  @override
  Future<void> signup(SignupRequest request) => _dataSource.signup(request);

  @override
  Future<AuthTokens> login(LoginRequest request) => _dataSource.login(request);

  @override
  Future<AuthTokens> googleSignIn(GoogleSignInRequest request) =>
      _dataSource.googleSignIn(request);

  @override
  Future<void> verifyOtp(OtpVerificationRequest request) =>
      _dataSource.verifyOtp(request);

  @override
  Future<void> resendOtp(ResendOtpRequest request) =>
      _dataSource.resendOtp(request);

  @override
  Future<void> logout() => _dataSource.logout();

  @override
  Future<AuthTokens> refreshToken(RefreshTokenRequest request) =>
      _dataSource.refreshToken(request);

  @override
  Future<void> forgotPassword(ForgotPasswordRequest request) =>
      _dataSource.forgotPassword(request);

  @override
  Future<void> resetPassword(ResetPasswordRequest request) =>
      _dataSource.resetPassword(request);
}

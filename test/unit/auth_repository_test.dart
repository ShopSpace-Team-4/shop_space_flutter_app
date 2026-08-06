import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shop_space/core/errors/failures.dart';
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
import 'package:shop_space/features/auth/repository/auth_repository.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

void main() {
  group('AuthRepositoryImpl', () {
    late MockAuthDataSource dataSource;
    late AuthRepositoryImpl repository;

    const tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');
    const signupRequest = SignupRequest(
      firstName: 'Omar',
      lastName: 'Hassan',
      email: 'omar@example.com',
      phone: '+201000000000',
      password: 'Pass1234',
    );
    const loginRequest =
        LoginRequest(email: 'omar@example.com', password: 'Pass1234');
    const googleRequest = GoogleSignInRequest(idToken: 'google-id-token');
    const otpRequest =
        OtpVerificationRequest(email: 'omar@example.com', otpCode: '123456');
    const resendRequest = ResendOtpRequest(email: 'omar@example.com');
    const refreshRequest = RefreshTokenRequest(refreshToken: 'refresh');
    const forgotRequest = ForgotPasswordRequest(email: 'omar@example.com');
    const resetRequest = ResetPasswordRequest(
      email: 'omar@example.com',
      otpCode: '123456',
      newPassword: 'NewPass123',
    );

    setUp(() {
      dataSource = MockAuthDataSource();
      repository = AuthRepositoryImpl(dataSource);
    });

    test('signup delegates to AuthDataSource', () async {
      when(() => dataSource.signup(signupRequest)).thenAnswer((_) async {});

      await repository.signup(signupRequest);

      verify(() => dataSource.signup(signupRequest)).called(1);
    });

    test('login delegates and returns the token pair', () async {
      when(() => dataSource.login(loginRequest)).thenAnswer((_) async => tokens);

      expect(await repository.login(loginRequest), tokens);

      verify(() => dataSource.login(loginRequest)).called(1);
    });

    test('googleSignIn delegates and returns the token pair', () async {
      when(() => dataSource.googleSignIn(googleRequest))
          .thenAnswer((_) async => tokens);

      expect(await repository.googleSignIn(googleRequest), tokens);

      verify(() => dataSource.googleSignIn(googleRequest)).called(1);
    });

    test('verifyOtp delegates to AuthDataSource', () async {
      when(() => dataSource.verifyOtp(otpRequest)).thenAnswer((_) async {});

      await repository.verifyOtp(otpRequest);

      verify(() => dataSource.verifyOtp(otpRequest)).called(1);
    });

    test('resendOtp delegates and returns otpDelivered', () async {
      when(() => dataSource.resendOtp(resendRequest))
          .thenAnswer((_) async => true);

      expect(await repository.resendOtp(resendRequest), isTrue);

      verify(() => dataSource.resendOtp(resendRequest)).called(1);
    });

    test('logout delegates to AuthDataSource', () async {
      when(() => dataSource.logout()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => dataSource.logout()).called(1);
    });

    test('refreshToken delegates and returns the token pair', () async {
      when(() => dataSource.refreshToken(refreshRequest))
          .thenAnswer((_) async => tokens);

      expect(await repository.refreshToken(refreshRequest), tokens);

      verify(() => dataSource.refreshToken(refreshRequest)).called(1);
    });

    test('forgotPassword delegates to AuthDataSource', () async {
      when(() => dataSource.forgotPassword(forgotRequest))
          .thenAnswer((_) async {});

      await repository.forgotPassword(forgotRequest);

      verify(() => dataSource.forgotPassword(forgotRequest)).called(1);
    });

    test('resetPassword delegates to AuthDataSource', () async {
      when(() => dataSource.resetPassword(resetRequest))
          .thenAnswer((_) async {});

      await repository.resetPassword(resetRequest);

      verify(() => dataSource.resetPassword(resetRequest)).called(1);
    });

    test('propagates typed Failures unchanged', () {
      when(() => dataSource.login(loginRequest))
          .thenThrow(const InvalidCredentials('invalid_credentials'));

      expect(
        () => repository.login(loginRequest),
        throwsA(isA<InvalidCredentials>()),
      );
    });
  });
}

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/core/errors/error_mapper.dart';
import 'package:shop_space/core/errors/failures.dart';

void main() {
  group('ErrorMapper', () {
    const mapper = ErrorMapper();

    DioException exception(
      DioExceptionType type, {
      int? statusCode,
      Map<String, dynamic>? body,
    }) {
      return DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: type,
        response: statusCode == null
            ? null
            : Response<dynamic>(
                requestOptions: RequestOptions(path: '/test'),
                statusCode: statusCode,
                data: body,
              ),
      );
    }

    DioException badResponse(int statusCode, Map<String, dynamic>? body) {
      return exception(DioExceptionType.badResponse,
          statusCode: statusCode, body: body);
    }

    test('maps timeouts to TimeoutFailure', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.transformTimeout,
      ]) {
        expect(mapper.map(exception(type)), isA<TimeoutFailure>(),
            reason: '$type');
      }
    });

    test('maps connectionError to OfflineFailure', () {
      expect(
        mapper.map(exception(DioExceptionType.connectionError)),
        isA<OfflineFailure>(),
      );
    });

    test('maps 401 to UnauthorizedFailure', () {
      final failure = mapper.map(
        exception(DioExceptionType.badResponse, statusCode: 401),
      );

      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.messageKey, ErrorMapper.unauthorizedMessageKey);
    });

    test('maps other 4xx to ValidationFailure', () {
      for (final code in [400, 404, 422]) {
        final failure = mapper.map(
          exception(DioExceptionType.badResponse, statusCode: code),
        );

        expect(failure, isA<ValidationFailure>(), reason: '$code');
        expect(failure.messageKey, ErrorMapper.validationMessageKey);
      }
    });

    test('maps 5xx to ServerFailure', () {
      for (final code in [500, 503]) {
        final failure = mapper.map(
          exception(DioExceptionType.badResponse, statusCode: code),
        );

        expect(failure, isA<ServerFailure>(), reason: '$code');
        expect(failure.messageKey, ErrorMapper.serverMessageKey);
      }
    });

    test('maps badResponse without a status code to ServerFailure', () {
      final failure = mapper.map(exception(DioExceptionType.badResponse));

      expect(failure, isA<ServerFailure>());
    });

    test('maps cancel/badCertificate/unknown to NetworkFailure', () {
      for (final type in [
        DioExceptionType.cancel,
        DioExceptionType.badCertificate,
        DioExceptionType.unknown,
      ]) {
        expect(mapper.map(exception(type)), isA<NetworkFailure>(),
            reason: '$type');
      }
    });

    group('auth business codes (envelope status field)', () {
      const cases = <(String, Failure)>[
        ('email_already_registered', EmailAlreadyRegistered('')),
        ('invalid_otp', InvalidOtp('')),
        ('otp_attempts_exceeded', OtpAttemptsExceeded('')),
        ('invalid_credentials', InvalidCredentials('')),
        ('email_not_verified', EmailNotVerified('')),
        ('google_signin_cancelled', GoogleSignInCancelled('')),
        ('rate_limited', RateLimited('')),
      ];

      for (final (code, failure) in cases) {
        test('maps $code to ${failure.runtimeType}', () {
          final mapped = mapper.map(
            badResponse(400, {'message': 'nope', 'status': code}),
          );

          expect(mapped.runtimeType, failure.runtimeType, reason: code);
        });
      }

      test('maps each code to its localized messageKey', () {
        const codeToKey = <String, String>{
          'email_already_registered': ErrorMapper.emailAlreadyRegisteredMessageKey,
          'invalid_otp': ErrorMapper.invalidOtpMessageKey,
          'otp_attempts_exceeded': ErrorMapper.otpAttemptsExceededMessageKey,
          'invalid_credentials': ErrorMapper.invalidCredentialsMessageKey,
          'email_not_verified': ErrorMapper.emailNotVerifiedMessageKey,
          'google_signin_cancelled': ErrorMapper.googleSignInCancelledMessageKey,
          'rate_limited': ErrorMapper.rateLimitedMessageKey,
        };

        codeToKey.forEach((code, key) {
          final failure = mapper.map(
            badResponse(400, {'message': 'nope', 'status': code}),
          );

          expect(failure.messageKey, key, reason: code);
        });
      });

      test('business code wins over the HTTP status code', () {
        for (final (code, failure) in cases) {
          final mapped = mapper.map(
            badResponse(401, {'message': 'nope', 'status': code}),
          );

          expect(mapped.runtimeType, failure.runtimeType,
              reason: '$code on 401');
        }
      });

      test('unknown status on 4xx falls back to ValidationFailure', () {
        for (final code in [400, 404, 409, 422, 429]) {
          final failure = mapper.map(
            badResponse(code, {'message': 'x', 'status': 'unknown_code'}),
          );

          expect(failure, isA<ValidationFailure>(), reason: '$code');
          expect(failure.messageKey, ErrorMapper.validationMessageKey,
              reason: '$code');
        }
      });

      test('unknown status on 401 falls back to UnauthorizedFailure', () {
        final failure = mapper.map(
          badResponse(401, {'message': 'x', 'status': 'unknown_code'}),
        );

        expect(failure, isA<UnauthorizedFailure>());
      });

      test('non-map error body falls back to status-code behavior', () {
        final failure = mapper.map(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response<dynamic>(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 400,
              data: 'plain text error',
            ),
          ),
        );

        expect(failure, isA<ValidationFailure>());
      });

      test('business code is ignored on 5xx', () {
        final failure = mapper.map(
          badResponse(500, {'message': 'x', 'status': 'email_already_registered'}),
        );

        expect(failure, isA<ServerFailure>());
      });
    });
  });
}

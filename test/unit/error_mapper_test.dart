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
    }) {
      return DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: type,
        response: statusCode == null
            ? null
            : Response<dynamic>(
                requestOptions: RequestOptions(path: '/test'),
                statusCode: statusCode,
              ),
      );
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
  });
}

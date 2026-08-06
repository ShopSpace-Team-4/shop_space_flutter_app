import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/core/errors/error_mapper.dart';
import 'package:shop_space/core/errors/failures.dart';
import 'package:shop_space/core/network/interceptors/envelope_interceptor.dart';
import 'package:shop_space/core/network/interceptors/error_interceptor.dart';
import 'package:shop_space/features/user/data/models/active_role_update_request.dart';
import 'package:shop_space/features/user/data/models/password_change_request.dart';
import 'package:shop_space/features/user/data/models/role_change_request.dart';
import 'package:shop_space/features/user/data/models/role_change_response.dart';
import 'package:shop_space/features/user/data/models/user.dart';
import 'package:shop_space/features/user/data/models/user_role.dart';
import 'package:shop_space/features/user/data/user_datasource.dart';

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

Map<String, dynamic> _userJson() => <String, dynamic>{
      'id': 'u1',
      'firstName': 'Omar',
      'lastName': 'Hassan',
      'email': 'omar@example.com',
      'phone': '+201000000000',
      'roles': <String>['tenant'],
      'activeRole': 'tenant',
      'isVerified': true,
    };

ResponseBody _userEnvelope() => _body(
      jsonEncode(<String, dynamic>{
        'message': 'ok',
        'status': 'success',
        'data': _userJson(),
      }),
      200,
    );

ResponseBody _roleChangeEnvelope() => _body(
      jsonEncode(<String, dynamic>{
        'message': 'ok',
        'status': 'success',
        'data': <String, dynamic>{
          'tokens': <String, dynamic>{
            'accessToken': 'access-1',
            'refreshToken': 'refresh-1',
          },
          'user': _userJson(),
        },
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
  group('UserDataSourceImpl', () {
    late RecordingAdapter adapter;
    late UserDataSourceImpl dataSource;

    setUp(() {
      adapter = RecordingAdapter();
      dataSource = UserDataSourceImpl(_dio(adapter));
    });

    test('getProfile GETs /users/me and returns the User', () async {
      adapter.onFetch = (_) async => _userEnvelope();

      final User user = await dataSource.getProfile();

      final RequestOptions options = adapter.requests.single;
      expect(options.method, 'GET');
      expect(options.path, '/users/me');
      expect(user.id, 'u1');
      expect(user.email, 'omar@example.com');
      expect(user.roles, const <UserRole>[UserRole.tenant]);
      expect(user.activeRole, UserRole.tenant);
    });

    test('changePassword PUTs /users/me/password with the request body',
        () async {
      await dataSource.changePassword(
        const PasswordChangeRequest(
          currentPassword: 'old-pass',
          newPassword: 'new-pass123',
        ),
      );

      final RequestOptions options = adapter.requests.single;
      expect(options.method, 'PUT');
      expect(options.path, '/users/me/password');
      expect(
        _bodyOf(options),
        <String, dynamic>{
          'currentPassword': 'old-pass',
          'newPassword': 'new-pass123',
        },
      );
    });

    test('switchActiveRole PATCHes /users/me/active-role and returns the User',
        () async {
      adapter.onFetch = (_) async => _userEnvelope();

      final User user = await dataSource.switchActiveRole(
        const ActiveRoleUpdateRequest(role: UserRole.landlord),
      );

      final RequestOptions options = adapter.requests.single;
      expect(options.method, 'PATCH');
      expect(options.path, '/users/me/active-role');
      expect(_bodyOf(options), <String, dynamic>{'role': 'landlord'});
      expect(user.id, 'u1');
    });

    test('addRole POSTs /users/me/roles and returns RoleChangeResponse',
        () async {
      adapter.onFetch = (_) async => _roleChangeEnvelope();

      final RoleChangeResponse response = await dataSource.addRole(
        const RoleChangeRequest(role: UserRole.landlord),
      );

      final RequestOptions options = adapter.requests.single;
      expect(options.method, 'POST');
      expect(options.path, '/users/me/roles');
      expect(_bodyOf(options), <String, dynamic>{'role': 'landlord'});
      expect(response.tokens.accessToken, 'access-1');
      expect(response.user.id, 'u1');
    });

    group('failure mapping', () {
      test('changePassword invalid_credentials -> InvalidCredentials', () {
        adapter.onFetch =
            (_) async => _errorEnvelope(ErrorMapper.codeInvalidCredentials, 401);

        expect(
          dataSource.changePassword(
            const PasswordChangeRequest(
              currentPassword: 'wrong',
              newPassword: 'new-pass123',
            ),
          ),
          throwsA(isA<InvalidCredentials>()),
        );
      });

      test('getProfile 401 -> UnauthorizedFailure', () {
        adapter.onFetch =
            (_) async => _errorEnvelope('unauthorized', 401);

        expect(dataSource.getProfile(), throwsA(isA<UnauthorizedFailure>()));
      });
    });
  });
}

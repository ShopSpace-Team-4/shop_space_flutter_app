import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/dio_failure.dart';
import 'models/active_role_update_request.dart';
import 'models/link_google_request.dart';
import 'models/password_change_request.dart';
import 'models/role_change_request.dart';
import 'models/role_change_response.dart';
import 'models/update_profile_request.dart';
import 'models/user.dart';

/// Raw network surface for the authenticated user endpoints
/// (`specs/002-auth-verification-roles/contracts/auth-api.md`). Methods throw
/// typed [Failure]s only — never raw [DioException]s.
abstract class UserDataSource {
  Future<User> getProfile();

  /// Updates the user's name and phone (`PUT /users/me`, API guide §5.2) and
  /// returns the resulting [User].
  Future<User> updateProfile(UpdateProfileRequest request);

  Future<void> changePassword(PasswordChangeRequest request);

  Future<User> switchActiveRole(ActiveRoleUpdateRequest request);

  Future<RoleChangeResponse> addRole(RoleChangeRequest request);

  /// Links a Google identity to the existing password account
  /// (`PATCH /users/me/link-google`, API guide §5.6). The response carries no
  /// tokens, so the caller keeps the current session.
  Future<void> linkGoogle(LinkGoogleRequest request);
}

@Injectable(as: UserDataSource)
class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<User> getProfile() async {
    final Response<dynamic> response =
        await _request<Response<dynamic>>(() => _dio.get<dynamic>('/users/me'));
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<User> updateProfile(UpdateProfileRequest request) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.put<dynamic>('/users/me', data: request.toJson()),
    );
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> changePassword(PasswordChangeRequest request) => _request<void>(
        () => _dio.put<dynamic>('/users/me/password', data: request.toJson()),
      );

  @override
  Future<User> switchActiveRole(ActiveRoleUpdateRequest request) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.patch<dynamic>('/users/me/active-role', data: request.toJson()),
    );
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<RoleChangeResponse> addRole(RoleChangeRequest request) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.post<dynamic>('/users/me/roles', data: request.toJson()),
    );
    return RoleChangeResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> linkGoogle(LinkGoogleRequest request) => _request<void>(
        () => _dio.patch<dynamic>('/users/me/link-google', data: request.toJson()),
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

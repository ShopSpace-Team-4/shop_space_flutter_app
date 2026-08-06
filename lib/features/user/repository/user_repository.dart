import 'package:injectable/injectable.dart';

import '../../../core/network/session_controller.dart';
import '../../../core/storage/token_storage.dart';
import '../data/models/active_role_update_request.dart';
import '../data/models/password_change_request.dart';
import '../data/models/role_change_request.dart';
import '../data/models/role_change_response.dart';
import '../data/models/user.dart';
import '../data/models/user_role.dart';
import '../data/user_datasource.dart';

/// Application use-case surface for everything behind a valid session
/// (contract `contracts/auth-api.md`). A repository interface method IS the use
/// case (constitution §Architecture). Methods surface only typed failures —
/// never raw exceptions (guaranteed by [UserDataSource]).
abstract class UserRepository {
  Future<User> getProfile();

  Future<User> switchActiveRole(UserRole role);

  /// Adds a role and returns the resulting [User]. Because the old access
  /// token may not carry the new role's permissions, the fresh token pair from
  /// [RoleChangeResponse] is written through the SAME path the refresh
  /// interceptor uses ([SessionController.onTokensUpdated]) BEFORE any caller
  /// sees the updated [User] (constitution §Roles & sessions).
  Future<User> addRole(UserRole role);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._dataSource, this._session);

  final UserDataSource _dataSource;
  final SessionController _session;

  @override
  Future<User> getProfile() => _dataSource.getProfile();

  @override
  Future<User> switchActiveRole(UserRole role) =>
      _dataSource.switchActiveRole(ActiveRoleUpdateRequest(role: role));

  @override
  Future<User> addRole(UserRole role) async {
    final RoleChangeResponse response =
        await _dataSource.addRole(RoleChangeRequest(role: role));
    await _session.onTokensUpdated(
      AuthTokens(
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
      ),
    );
    return response.user;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _dataSource.changePassword(
        PasswordChangeRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
}

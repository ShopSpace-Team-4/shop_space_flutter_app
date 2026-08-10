import 'package:injectable/injectable.dart';

import '../../../core/network/session_controller.dart';
import '../../../core/storage/token_storage.dart';
import '../data/models/active_role_update_request.dart';
import '../data/models/link_google_request.dart';
import '../data/models/password_change_request.dart';
import '../data/models/role_change_request.dart';
import '../data/models/role_change_response.dart';
import '../data/models/update_profile_request.dart';
import '../data/models/user.dart';
import '../data/models/user_role.dart';
import '../data/user_datasource.dart';

/// Application use-case surface for everything behind a valid session
/// (contract `contracts/auth-api.md`). A repository interface method IS the use
/// case (constitution §Architecture). Methods surface only typed failures —
/// never raw exceptions (guaranteed by [UserDataSource]).
abstract class UserRepository {
  /// Returns the signed-in user's profile. The repository is a
  /// [lazySingleton] shared by startup hydration ([AuthSessionCubit]) and the
  /// home/profile screens, so [getProfile] serves a single in-flight request to
  /// every concurrent caller and caches the result until [invalidate].
  Future<User> getProfile();

  Future<User> switchActiveRole(UserRole role);

  /// Adds a role and returns the resulting [User]. Because the old access
  /// token may not carry the new role's permissions, the fresh token pair from
  /// [RoleChangeResponse] is written through the SAME path the refresh
  /// interceptor uses ([SessionController.onTokensUpdated]) BEFORE any caller
  /// sees the updated [User] (constitution §Roles & sessions).
  Future<User> addRole(UserRole role);

  /// Updates the user's name and phone (`PUT /users/me`, API guide §5.2) and
  /// returns the resulting [User], which is immediately recached.
  Future<User> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Links the signed-in Google identity to the existing password account
  /// (`PATCH /users/me/link-google`, API guide §5.6). Unlike [addRole] this
  /// response carries no token pair, so the current session is left untouched.
  /// A cancelled Google sheet must never surface as an error (the caller maps
  /// it to a silent no-op).
  Future<void> linkGoogle(String idToken);

  /// Clears the cached profile so the next [getProfile] hits the network. The
  /// cache is intentionally never populated on failure, so a failed fetch is
  /// naturally retried on the next call.
  void invalidate();
}

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._dataSource, this._session) {
    // Session end (sign-out / expiry) must never leak a cached profile into a
    // new session.
    _session.sessionExpired.listen((_) => invalidate());
  }

  final UserDataSource _dataSource;
  final SessionController _session;

  User? _cached;
  Future<User>? _inFlight;

  /// Bumped by [invalidate] so an in-flight fetch that lost the race can
  /// neither repopulate the cache nor clear a newer in-flight request.
  int _generation = 0;

  @override
  Future<User> getProfile() {
    final User? cached = _cached;
    if (cached != null) return Future.value(cached);
    return _inFlight ??= _fetchAndCache();
  }

  Future<User> _fetchAndCache() async {
    final int generation = _generation;
    try {
      final User user = await _dataSource.getProfile();
      if (generation == _generation) {
        _cached = user;
      }
      return user;
    } finally {
      if (generation == _generation) {
        _inFlight = null;
      }
    }
  }

  @override
  Future<User> switchActiveRole(UserRole role) async {
    final User user = await _dataSource.switchActiveRole(
      ActiveRoleUpdateRequest(role: role),
    );
    _cached = user;
    return user;
  }

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
    _cached = response.profile;
    return response.profile;
  }

  @override
  Future<User> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final User user = await _dataSource.updateProfile(
      UpdateProfileRequest(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      ),
    );
    _cached = user;
    return user;
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

  @override
  Future<void> linkGoogle(String idToken) =>
      _dataSource.linkGoogle(LinkGoogleRequest(idToken: idToken));

  @override
  void invalidate() {
    _generation++;
    _cached = null;
    _inFlight = null;
  }
}

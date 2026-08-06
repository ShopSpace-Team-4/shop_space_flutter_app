import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/session_controller.dart';
import '../../../../core/router/route_guards.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../user/data/models/user.dart';
import '../../../user/data/models/user_role.dart';
import '../../../user/repository/user_repository.dart';
import '../../google/auth_google_service.dart';
import '../../repository/auth_repository.dart';

part 'auth_session_cubit.freezed.dart';

@freezed
abstract class AuthSessionState with _$AuthSessionState {
  /// No valid session. [isBootstrapping] drives the startup splash while
  /// stored tokens are inspected.
  const factory AuthSessionState.unauthenticated({
    @Default(false) bool isBootstrapping,
  }) = AuthSessionUnauthenticated;

  /// Valid session. [isHydrating] is true while the profile is fetched to
  /// restore roles, `activeRole` and verification (D3). Roles are exposed as
  /// names to match [SessionReader].
  const factory AuthSessionState.authenticated({
    @Default(<String>{}) Set<String> roles,
    @Default(UserRole.tenant) UserRole activeRole,
    @Default(false) bool isVerified,
    @Default(true) bool isHydrating,
    @Default(false) bool isBootstrapping,
  }) = AuthSessionAuthenticated;
}

/// Real session owner (T017): restores/hydrates a stored session on startup,
/// persists fresh token pairs, and clears the session on expiry/sign-out.
///
/// Registered as the app's [SessionReader] (T020). Hydration follows D3: a
/// valid stored access token unblocks the UI immediately; profile fetch
/// failure is non-fatal except for a final 401, which drops the session.
@LazySingleton(as: SessionReader)
class AuthSessionCubit extends Cubit<AuthSessionState>
    implements SessionReader {
  AuthSessionCubit({
    required TokenStorage storage,
    required SessionController sessionController,
    required UserRepository userRepository,
    required AuthRepository authRepository,
    required AuthGoogleService googleAuth,
  })  : _storage = storage,
        _sessionController = sessionController,
        _userRepository = userRepository,
        _authRepository = authRepository,
        _googleAuth = googleAuth,
        super(const AuthSessionState.unauthenticated(isBootstrapping: true)) {
    // Storage is already cleared upstream by the session-expiry interceptor
    // (US3); this only resets the in-memory state so guards and UI react.
    _sessionController.sessionExpired.listen((_) => clearSession());
  }

  final TokenStorage _storage;
  final SessionController _sessionController;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  final AuthGoogleService _googleAuth;

  @override
  bool get isAuthenticated => state is AuthSessionAuthenticated;

  @override
  bool get isBootstrapping {
    final AuthSessionState current = state;
    return current is AuthSessionUnauthenticated && current.isBootstrapping;
  }

  @override
  Set<String> get roles {
    final AuthSessionState current = state;
    return current is AuthSessionAuthenticated ? current.roles : const {};
  }

  /// Startup: restore a stored session, then hydrate the profile in the
  /// background (D3).
  Future<void> initialize() async {
    emit(const AuthSessionState.unauthenticated(isBootstrapping: true));
    final AuthTokens? tokens = await _storage.read();
    if (tokens == null) {
      emit(const AuthSessionState.unauthenticated(isBootstrapping: false));
      return;
    }
    _restore(tokens);
  }

  /// Persist a fresh token pair (e.g. from login) and enter a session.
  Future<void> authenticate(AuthTokens tokens) async {
    await _sessionController.onTokensUpdated(tokens);
    _restore(tokens);
  }

  /// Persist a refreshed token pair (e.g. after `addRole`) without disrupting
  /// the current session state (T017).
  Future<void> updateTokens(AuthTokens tokens) async {
    await _sessionController.onTokensUpdated(tokens);
  }

  /// Force local sign-out; server notification is best-effort and never
  /// blocks the local transition. Google account disconnection is also
  /// best-effort (T017).
  Future<void> signOut() async {
    try {
      await _authRepository.logout();
    } catch (_) {
      // Best-effort; the local session is cleared regardless.
    }
    try {
      await _googleAuth.signOut();
    } catch (_) {
      // Best-effort; the local session is cleared regardless.
    }
    await _sessionController.onSessionExpired();
    emit(const AuthSessionState.unauthenticated(isBootstrapping: false));
  }

  /// React to a session-expired signal (storage already cleared upstream).
  void clearSession() {
    if (state is AuthSessionUnauthenticated) return;
    emit(const AuthSessionState.unauthenticated(isBootstrapping: false));
  }

  /// Reflect a changed role set (from [RolesCubit]) on the session so guards
  /// re-evaluate (T033).
  void updateRoles(Set<String> roles) {
    final AuthSessionState current = state;
    if (current is! AuthSessionAuthenticated) return;
    emit(current.copyWith(roles: roles));
  }

  /// Reflect a changed [activeRole] (from [RolesCubit]) on the session (T033).
  void updateActiveRole(UserRole role) {
    final AuthSessionState current = state;
    if (current is! AuthSessionAuthenticated) return;
    emit(current.copyWith(activeRole: role));
  }

  void _restore(AuthTokens tokens) {
    emit(const AuthSessionState.authenticated(isHydrating: true));
    _hydrateUser(tokens);
  }

  Future<void> _hydrateUser(AuthTokens tokens) async {
    try {
      final User user = await _userRepository.getProfile();
      emit(AuthSessionState.authenticated(
        roles: user.roles.map((UserRole role) => role.name).toSet(),
        activeRole: user.activeRole,
        isVerified: user.isVerified,
        isHydrating: false,
        isBootstrapping: false,
      ));
    } on UnauthorizedFailure {
      // Final 401 during hydration: the session is no longer valid (D3).
      emit(const AuthSessionState.unauthenticated(isBootstrapping: false));
    } catch (_) {
      // Non-fatal: keep the session; roles/`activeRole` restore on the next
      // successful profile fetch.
      emit(const AuthSessionState.authenticated(isHydrating: false));
    }
  }
}

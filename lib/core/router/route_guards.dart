import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/user/data/models/user_role.dart';

/// Reads the current session and full role set for redirect guards.
///
/// Guards read [roles] — never a single `activeRole` — per constitution §6.
abstract interface class SessionReader {
  /// Whether a valid session exists.
  bool get isAuthenticated;

  /// The full set of roles on the account.
  Set<String> get roles;
}

/// Phase 0 default [SessionReader]: no session exists yet and every account
/// is treated as an unauthenticated tenant.
///
/// Registered through the standard DI path (`@singleton` + build_runner) so
/// guards and future features resolve the same interface. Phase 1 replaces
/// this concrete type with a reader backed by the real session store once
/// sign-in exists — no consumers need to change.
@Singleton(as: SessionReader)
class DefaultSessionReader implements SessionReader {
  const DefaultSessionReader();

  @override
  bool get isAuthenticated => false;

  @override
  Set<String> get roles => {UserRole.tenant.name};
}

/// Redirects unauthenticated users to [signInPath].
///
/// Phase 1 hook: attach to protected routes via go_router, e.g.
/// `redirect: (context, state) => authGuard(context, state)`.
class AuthGuard {
  const AuthGuard({required this.session, this.signInPath = '/login'});

  final SessionReader session;
  final String signInPath;

  String? call(BuildContext context, GoRouterState state) {
    if (!session.isAuthenticated) {
      return signInPath;
    }
    return null;
  }
}

/// Redirects users lacking [requiredRole] to [fallbackPath].
///
/// Permission checks read `session.roles`, never `activeRole` alone
/// (constitution §6). Phase 1 hook: attach via go_router, e.g.
/// `redirect: (context, state) => guard(context, state)`.
class RoleGuard {
  const RoleGuard({
    required this.session,
    required this.requiredRole,
    this.fallbackPath = '/',
  });

  final SessionReader session;
  final String requiredRole;
  final String fallbackPath;

  String? call(BuildContext context, GoRouterState state) {
    if (!session.roles.contains(requiredRole)) {
      return fallbackPath;
    }
    return null;
  }
}

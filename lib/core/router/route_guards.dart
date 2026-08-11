import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Reads the current session and full role set for redirect guards.
///
/// Guards read [roles] — never a single `activeRole` — per constitution §6.
abstract interface class SessionReader {
  /// Whether a valid session exists.
  bool get isAuthenticated;

  /// True while a stored session is still being resolved on startup. Guards
  /// must not redirect during bootstrap (production awaits `initialize()`
  /// before `runApp`, so this is only observable pre-init).
  bool get isBootstrapping;

  /// The full set of roles on the account.
  Set<String> get roles;
}

/// Reads first-launch progress for the onboarding gate.
///
/// Guards must not redirect while [isBootstrapping] is true (production
/// awaits `initialize()` before `runApp`, so this is only observable
/// pre-init). [isCompleted] gates every route to `/onboarding` until the
/// flow is finished.
abstract interface class OnboardingReader {
  /// Whether the onboarding flag has been persisted.
  bool get isCompleted;

  /// True while the persisted flag is still being resolved on startup.
  bool get isBootstrapping;
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
    if (session.isBootstrapping) {
      return null;
    }
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

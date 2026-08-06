import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubits/auth_session_cubit.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/user/presentation/screens/change_password_screen.dart';
import '../../features/user/presentation/screens/profile_screen.dart';
import '../localization/app_localizations.dart';
import '../responsive/app_adaptive_shell.dart';
import '../widgets/placeholder_screen.dart';
import 'route_guards.dart';

/// Forwards [AuthSessionCubit] emissions to go_router so redirect guards
/// re-evaluate when the session changes (T021). The router keeps this alive
/// via `refreshListenable`; it is only constructed when a session is wired.
class _SessionRefresh extends ChangeNotifier {
  _SessionRefresh(AuthSessionCubit session) {
    _subscription = session.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthSessionState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Route table (Phase 1).
///
/// Auth routes (login/signup/otp/reset) are public. Everything behind a
/// session (`/`, `/profile`, `/change-password`) is wrapped in an [AuthGuard];
/// when no session is wired (widget tests, pre-bootstrap) the guard is absent
/// and behavior matches Phase 0. Unknown routes fall back to a graceful,
/// localized [errorBuilder] instead of crashing.
class AppRouter {
  AppRouter({AuthSessionCubit? session}) {
    final AuthGuard? guard = session == null
        ? null
        : AuthGuard(session: session, signInPath: '/login');

    _router = GoRouter(
      refreshListenable: session == null ? null : _SessionRefresh(session),
      routes: [
        GoRoute(
          path: '/',
          redirect: guard?.call,
          builder: (context, state) {
            final AppLocalizations l10n = AppLocalizations.of(context);
            final List<NavigationDestination> destinations =
                _shellDestinations(l10n);
            return AppAdaptiveShell(
              body: const HomeScreen(),
              destinations: destinations,
              onDestinationSelected: (index) {
                if (index == _profileDestinationIndex(destinations, l10n)) {
                  context.go('/profile');
                }
              },
            );
          },
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const AuthScreen(initialIndex: 0),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const AuthScreen(initialIndex: 1),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) => OtpScreen(
            email: state.uri.queryParameters['email'],
          ),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/reset-password',
          builder: (context, state) => ResetPasswordScreen(
            email: state.uri.queryParameters['email'],
          ),
        ),
        GoRoute(
          path: '/profile',
          redirect: guard?.call,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/change-password',
          redirect: guard?.call,
          builder: (context, state) => const ChangePasswordScreen(),
        ),
        _placeholderRoute('/listings', (l10n) => l10n.navListings),
        _placeholderRoute('/search', (l10n) => l10n.navSearch),
        _placeholderRoute('/advisor', (l10n) => l10n.navAdvisor),
        _placeholderRoute('/inquiries', (l10n) => l10n.navInquiries),
      ],
      errorBuilder: (context, state) {
        final AppLocalizations l10n = AppLocalizations.of(context);
        return AppPlaceholderScreen(title: l10n.routeNotFound);
      },
    );
  }

  late final GoRouter _router;

  GoRouter get router => _router;

  GoRoute _placeholderRoute(
    String path,
    String Function(AppLocalizations l10n) title,
  ) {
    return GoRoute(
      path: path,
      builder: (context, state) {
        final AppLocalizations l10n = AppLocalizations.of(context);
        return AppPlaceholderScreen(title: title(l10n));
      },
    );
  }

  /// Index of the Profile destination, so the shell's Profile tap navigates
  /// to `/profile` while other destinations stay index-only for later phases.
  int _profileDestinationIndex(
    List<NavigationDestination> destinations,
    AppLocalizations l10n,
  ) {
    return destinations.indexWhere((d) => d.label == l10n.navProfile);
  }

  List<NavigationDestination> _shellDestinations(AppLocalizations l10n) {
    return [
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: l10n.navHome,
      ),
      NavigationDestination(
        icon: const Icon(Icons.search_outlined),
        selectedIcon: const Icon(Icons.search),
        label: l10n.navSearch,
      ),
      NavigationDestination(
        icon: const Icon(Icons.list_alt_outlined),
        selectedIcon: const Icon(Icons.list_alt),
        label: l10n.navListings,
      ),
      NavigationDestination(
        icon: const Icon(Icons.support_agent_outlined),
        selectedIcon: const Icon(Icons.support_agent),
        label: l10n.navAdvisor,
      ),
      NavigationDestination(
        icon: const Icon(Icons.chat_bubble_outline),
        selectedIcon: const Icon(Icons.chat_bubble),
        label: l10n.navInquiries,
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: l10n.navProfile,
      ),
    ];
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubits/auth_session_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/home_screen.dart';
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
          builder: (context, state) => AppAdaptiveShell(
            body: const HomeScreen(),
            destinations: _shellDestinations(context),
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) => OtpScreen(
            email: state.uri.queryParameters['email'],
          ),
        ),
        _placeholderRoute('/reset-password', (l10n) => l10n.authResetPassword),
        _protectedPlaceholderRoute('/profile', (l10n) => l10n.navProfile, guard),
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

  GoRoute _protectedPlaceholderRoute(
    String path,
    String Function(AppLocalizations l10n) title,
    AuthGuard? guard,
  ) {
    return GoRoute(
      path: path,
      redirect: guard?.call,
      builder: (context, state) {
        final AppLocalizations l10n = AppLocalizations.of(context);
        return AppPlaceholderScreen(title: title(l10n));
      },
    );
  }

  List<NavigationDestination> _shellDestinations(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
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

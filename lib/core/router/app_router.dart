import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/advisor/presentation/screens/advisor_chat_screen.dart';
import '../../features/auth/presentation/cubits/auth_session_cubit.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/listing/presentation/list_a_shop_flow.dart';
import '../../features/listing/presentation/screens/listing_detail_screen.dart';
import '../../features/listing/presentation/screens/listing_form_screen.dart';
import '../../features/listing/presentation/screens/my_listings_screen.dart';
import '../../features/onboarding/presentation/cubits/onboarding_cubit.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/saved/presentation/screens/saved_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/search/presentation/screens/shop_detail_screen.dart';
import '../../features/user/presentation/screens/change_password_screen.dart';
import '../../features/user/presentation/screens/profile_screen.dart';
import '../../features/user/presentation/screens/settings_screen.dart';
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

/// Forwards [OnboardingCubit] emissions to go_router so the first-launch
/// redirect re-evaluates the moment the flow is completed (or unblocked from
/// bootstrap). Kept alive by the router via `refreshListenable`.
class _OnboardingRefresh extends ChangeNotifier {
  _OnboardingRefresh(OnboardingCubit onboarding) {
    _subscription = onboarding.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<OnboardingState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Route table (Phase 1).
///
/// The four main tabs (Home, Search, Saved, Profile) live inside a single
/// [StatefulShellRoute.indexedStack] so the `AppAdaptiveShell` navigation bar
/// stays visible on every tab. Auth routes (login/signup/otp/reset) are
/// public and sit outside the shell (no nav bar, matching Figma `Frame 51`).
/// Everything behind a session is wrapped in an [AuthGuard]; when no session
/// is wired (pre-bootstrap) the guard is absent and behavior matches Phase 0.
/// Unknown routes fall back to a graceful, localized [errorBuilder] instead
/// of crashing.
class AppRouter {
  AppRouter({AuthSessionCubit? session, OnboardingCubit? onboarding})
      : _session = session,
        _onboarding = onboarding {
    final AuthGuard? guard = session == null
        ? null
        : AuthGuard(session: session, signInPath: '/login');

    _router = GoRouter(
      // First-launch gate runs ahead of per-route AuthGuards: while onboarding
      // is incomplete every location lands on `/onboarding` (unless already
      // there); once completed, exiting `/onboarding` goes to `/` when
      // authenticated or `/login` otherwise.
      redirect: _onboardingRedirect,
      refreshListenable: _refreshListenable(session, onboarding),
      routes: [
        StatefulShellRoute.indexedStack(
          redirect: guard?.call,
          builder: (context, state, navigationShell) {
            return AppAdaptiveShell(
              navigationShell: navigationShell,
              onAddPressed: () => openCreateListingFlow(context),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/search',
                  builder: (context, state) => SearchScreen(
                    focusRequested:
                        state.uri.queryParameters['focus'] == 'search',
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/saved',
                  builder: (context, state) => const SavedScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
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
          path: '/change-password',
          redirect: guard?.call,
          builder: (context, state) => const ChangePasswordScreen(),
        ),
        GoRoute(
          path: '/settings',
          redirect: guard?.call,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/my-listings',
          redirect: guard?.call,
          builder: (context, state) => const MyListingsScreen(),
        ),
        GoRoute(
          path: '/my-listings/:listingId',
          redirect: guard?.call,
          builder: (context, state) => ListingDetailScreen(
            listingId: state.pathParameters['listingId'] ?? '',
          ),
        ),
        GoRoute(
          path: '/search/:listingId',
          redirect: guard?.call,
          // US2 (T031): tenant shop detail — pushed on compact/medium; the
          // expanded two-pane (T032) renders ShopDetailPane in-place instead.
          builder: (context, state) => ShopDetailScreen(
            listingId: state.pathParameters['listingId'] ?? '',
          ),
        ),
        GoRoute(
          path: '/listing-form',
          redirect: guard?.call,
          builder: (context, state) => const ListingFormScreen(),
        ),
        GoRoute(
          path: '/listing-form/:listingId',
          redirect: guard?.call,
          builder: (context, state) => ListingFormScreen(
            listingId: state.pathParameters['listingId'],
          ),
        ),
        // US1 (T028): the Advisor is a guarded full-screen route outside the
        // shell — the same AuthGuard pattern as `/change-password`/`/search/:listingId`
        // (FR-001: signed-out access redirects to `/login`).
        GoRoute(
          path: '/advisor',
          redirect: guard?.call,
          builder: (context, state) => const AdvisorChatScreen(),
        ),
        // First-launch onboarding: public (no session guard) and outside the
        // shell. The global [redirect] keeps it front-and-center until the
        // flag is completed; it is never reachable again once done.
        GoRoute(
          path: _onboardingPath,
          builder: (context, state) => const OnboardingScreen(),
        ),
      ],
      errorBuilder: (context, state) {
        final AppLocalizations l10n = AppLocalizations.of(context);
        return AppPlaceholderScreen(title: l10n.routeNotFound);
      },
    );
  }

  static const String _onboardingPath = '/onboarding';

  final AuthSessionCubit? _session;
  final OnboardingCubit? _onboarding;

  late final GoRouter _router;

  GoRouter get router => _router;

  /// Combined refresh listener so both the session and the onboarding flag
  /// re-evaluate redirects (completion leaves `/onboarding`, a fresh sign-in
  /// unlocks auth-guarded routes).
  static Listenable? _refreshListenable(
    AuthSessionCubit? session,
    OnboardingCubit? onboarding,
  ) {
    return Listenable.merge([
      if (session != null) _SessionRefresh(session),
      if (onboarding != null) _OnboardingRefresh(onboarding),
    ]);
  }

  /// First-launch gate: the top-level `redirect` runs before every per-route
  /// AuthGuard. During bootstrap both readers are unblocked before `runApp`,
  /// so no redirect fires while flags are unresolved (no first-frame flash).
  String? _onboardingRedirect(BuildContext context, GoRouterState state) {
    final OnboardingCubit? onboarding = _onboarding;
    if (onboarding == null || onboarding.isBootstrapping) {
      return null;
    }
    final bool isOnOnboarding = state.matchedLocation == _onboardingPath;
    if (!onboarding.isCompleted) {
      return isOnOnboarding ? null : _onboardingPath;
    }
    if (isOnOnboarding) {
      return _session?.isAuthenticated == true ? '/' : '/login';
    }
    return null;
  }
}

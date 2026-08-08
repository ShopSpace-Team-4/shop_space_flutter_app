import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
import '../../features/listing/presentation/screens/saved_screen.dart';
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
/// The four main tabs (Home, Search, Saved, Profile) live inside a single
/// [StatefulShellRoute.indexedStack] so the `AppAdaptiveShell` navigation bar
/// stays visible on every tab. Auth routes (login/signup/otp/reset) are
/// public and sit outside the shell (no nav bar, matching Figma `Frame 51`).
/// Everything behind a session is wrapped in an [AuthGuard]; when no session
/// is wired (pre-bootstrap) the guard is absent and behavior matches Phase 0.
/// Unknown routes fall back to a graceful, localized [errorBuilder] instead
/// of crashing.
class AppRouter {
  AppRouter({AuthSessionCubit? session}) {
    final AuthGuard? guard = session == null
        ? null
        : AuthGuard(session: session, signInPath: '/login');

    _router = GoRouter(
      refreshListenable: session == null ? null : _SessionRefresh(session),
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
                  builder: (context, state) => AppPlaceholderScreen(
                    title: AppLocalizations.of(context).navSearch,
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
}

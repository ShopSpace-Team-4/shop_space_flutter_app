import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/home/presentation/home_screen.dart';
import '../localization/app_localizations.dart';
import '../responsive/app_adaptive_shell.dart';
import '../widgets/placeholder_screen.dart';

/// Phase 0 route table.
///
/// Registers a placeholder route for every planned feature area (plan.md
/// Scale/Scope): auth login/signup/otp/reset, user profile, listings, search,
/// advisor, inquiries. No feature folders exist in Phase 0 — every non-home
/// route renders the shared [AppPlaceholderScreen]. Unknown routes fall back
/// to a graceful, localized [errorBuilder] instead of crashing.
@singleton
class AppRouter {
  AppRouter() {
    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => AppAdaptiveShell(
            body: const HomeScreen(),
            destinations: _shellDestinations(context),
          ),
        ),
        _placeholderRoute('/login', (l10n) => l10n.authLogin),
        _placeholderRoute('/signup', (l10n) => l10n.authSignup),
        _placeholderRoute('/otp', (l10n) => l10n.authOtp),
        _placeholderRoute('/reset-password', (l10n) => l10n.authResetPassword),
        _placeholderRoute('/profile', (l10n) => l10n.navProfile),
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

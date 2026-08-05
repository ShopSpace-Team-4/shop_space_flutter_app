import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'package:shop_space/bootstrap.dart';
import 'package:shop_space/core/di/injectable.dart';
import 'package:shop_space/core/localization/localization_cubit.dart';
import 'package:shop_space/core/router/app_router.dart';

/// App-launch smoke test (T063): the themed home must render inside the
/// correct adaptive shell at every surface size × locale with no exceptions
/// (SC-001, constitution §7).
///
/// Phase 0 makes no network calls on startup, so a successful launch to the
/// home placeholder is the full integration contract exercised here.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Host-run integration tests have no platform plugin registered; provide
    // the in-memory SharedPreferencesAsync backend (T055 precedent) so eager
    // DI construction of [PreferencesService] succeeds.
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    await configureDependencies();
  });

  const Map<String, Size> sizes = {
    'compact': Size(360, 800),
    'medium': Size(768, 1024),
    'expanded': Size(1280, 800),
  };

  for (final MapEntry<String, Size> size in sizes.entries) {
    for (final String localeCode in const ['en', 'ar']) {
      testWidgets(
          'app launches at ${size.key} (${size.value.width}dp) in $localeCode',
          (tester) async {
        final Size surface = size.value;
        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = surface;
        addTearDown(tester.view.reset);

        final LocalizationCubit localizationCubit =
            getIt<LocalizationCubit>();
        await localizationCubit.setLocale(Locale(localeCode));

        await tester.pumpWidget(
          ShopSpaceApp(
            localizationCubit: localizationCubit,
            router: getIt<AppRouter>().router,
          ),
        );
        await tester.pumpAndSettle();

        // No unhandled exceptions during launch/first frame (SC-001).
        expect(tester.takeException(), isNull);

        // Themed home renders inside the correct shell.
        final Finder bar = find.byType(NavigationBar);
        final Finder rail = find.byType(NavigationRail);
        if (surface.width < 600) {
          expect(bar, findsOneWidget);
          expect(rail, findsNothing);
        } else {
          expect(rail, findsOneWidget);
          expect(bar, findsNothing);
        }

        // Arabic resolves to RTL, English to LTR (constitution §7).
        final TextDirection direction = Directionality.of(
          tester.element(find.byType(Scaffold).first),
        );
        expect(
          direction,
          localeCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        );
      });
    }
  }
}

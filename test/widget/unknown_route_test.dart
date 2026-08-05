import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/core/localization/app_localizations.dart';
import 'package:shop_space/core/router/app_router.dart';

void main() {
  testWidgets('unknown route renders graceful fallback without crashing',
      (tester) async {
    final AppRouter appRouter = AppRouter();
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter.router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar')],
      ),
    );
    await tester.pumpAndSettle();

    appRouter.router.go('/route/that/does/not/exist');
    await tester.pumpAndSettle();

    final AppLocalizations l10n =
        await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.routeNotFound), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

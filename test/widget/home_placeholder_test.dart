import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/core/localization/app_localizations.dart';
import 'package:shop_space/features/home/presentation/home_screen.dart';

Future<void> pumpHome(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomeScreen(),
    ),
  );
}

void main() {
  testWidgets('home placeholder renders with localized content', (tester) async {
    await pumpHome(tester);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text(l10n.appTitle), findsWidgets);
    expect(find.text(l10n.placeholderBody), findsOneWidget);
  });
}

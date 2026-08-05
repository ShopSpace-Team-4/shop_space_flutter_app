import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/core/localization/app_localizations.dart';
import 'package:shop_space/core/responsive/app_adaptive_shell.dart';

const _destinations = <NavigationDestination>[
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.search_outlined),
    selectedIcon: Icon(Icons.search),
    label: 'Search',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outline),
    selectedIcon: Icon(Icons.person),
    label: 'Profile',
  ),
];

Future<void> pumpShell(WidgetTester tester, Size size, Locale locale) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: const AppAdaptiveShell(destinations: _destinations),
      ),
    ),
  );
}

void main() {
  const sizes = {
    'compact': Size(360, 800),
    'medium': Size(768, 1024),
    'expanded': Size(1280, 800),
  };

  for (final entry in sizes.entries) {
    for (final locale in const [Locale('en'), Locale('ar')]) {
      testWidgets('${entry.key} renders in ${locale.languageCode} (RTL-safe)',
          (tester) async {
        await pumpShell(tester, entry.value, locale);

        expect(find.byType(AppAdaptiveShell), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('Arabic locale applies RTL directionality', (tester) async {
    await pumpShell(tester, const Size(360, 800), const Locale('ar'));

    expect(Directionality.of(tester.element(find.byType(AppAdaptiveShell))),
        TextDirection.rtl);
  });
}

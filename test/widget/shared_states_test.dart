import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/core/errors/failures.dart';
import 'package:shop_space/core/localization/app_localizations.dart';
import 'package:shop_space/core/widgets/app_empty_view.dart';
import 'package:shop_space/core/widgets/app_error_view.dart';
import 'package:shop_space/core/widgets/app_loading_view.dart';

const Size _compact = Size(360, 800);
const Size _expanded = Size(1280, 900);

Future<void> pumpState(
  WidgetTester tester,
  Size size,
  Widget child,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('AppLoadingView', () {
    testWidgets('renders without overflow at compact', (tester) async {
      await pumpState(tester, _compact, const AppLoadingView());

      expect(find.byType(AppLoadingView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without overflow at expanded', (tester) async {
      await pumpState(tester, _expanded, const AppLoadingView());

      expect(find.byType(AppLoadingView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('AppEmptyView', () {
    testWidgets('renders without overflow at compact', (tester) async {
      await pumpState(tester, _compact, const AppEmptyView());

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without overflow at expanded', (tester) async {
      await pumpState(tester, _expanded, const AppEmptyView());

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('AppErrorView', () {
    testWidgets('renders without overflow at compact', (tester) async {
      await pumpState(
        tester,
        _compact,
        AppErrorView(
          failure: const NetworkFailure('errorNetwork'),
          onRetry: () {},
        ),
      );

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without overflow at expanded', (tester) async {
      await pumpState(
        tester,
        _expanded,
        AppErrorView(
          failure: const ServerFailure('errorServer'),
          onRetry: () {},
        ),
      );

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Retry triggers the onRetry callback', (tester) async {
      var retried = false;
      await pumpState(
        tester,
        _compact,
        AppErrorView(
          failure: const NetworkFailure('errorNetwork'),
          onRetry: () => retried = true,
        ),
      );

      await tester.tap(find.text(l10n.retry));
      await tester.pump();

      expect(retried, isTrue);
    });

    testWidgets(
      'offline variant renders localized offline message with working Retry',
      (tester) async {
        var retried = false;
        await pumpState(
          tester,
          _compact,
          AppErrorView(
            failure: const OfflineFailure('errorOffline'),
            onRetry: () => retried = true,
          ),
        );

        expect(find.text(l10n.errorOffline), findsOneWidget);

        await tester.tap(find.text(l10n.retry));
        await tester.pump();

        expect(retried, isTrue);
      },
    );

    testWidgets(
      'unauthorized variant renders a sign-in surface that redirects',
      (tester) async {
        var signedIn = false;
        await pumpState(
          tester,
          _compact,
          AppErrorView(
            failure: const UnauthorizedFailure('errorUnauthorized'),
            onRetry: () {},
            onSignIn: () => signedIn = true,
          ),
        );

        expect(find.text(l10n.errorUnauthorized), findsOneWidget);

        await tester.tap(find.text(l10n.authLogin));
        await tester.pump();

        expect(signedIn, isTrue);
      },
    );
  });
}

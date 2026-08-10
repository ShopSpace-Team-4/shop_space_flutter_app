import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injectable.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/localization_cubit.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/google/auth_google_service.dart';
import 'features/auth/presentation/cubits/auth_session_cubit.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load `.env` before any dependency reads config: `AppEnv`, Dio `baseUrl`,
  // and the Google Sign-In client IDs all resolve from it. The file is
  // bundled as a Flutter asset; `isOptional` tolerates a missing/empty file
  // (it's git-ignored) — the app still builds and runs with AppEnv defaults
  // (T026). Missing Google IDs surface later as a `ShopSpace.auth.google`
  // WARNING banner.
  await dotenv.load(fileName: '.env', isOptional: true);

  await configureDependencies();

  final LocalizationCubit localizationCubit = getIt<LocalizationCubit>();
  final AuthSessionCubit sessionCubit = getIt<AuthSessionCubit>();
  final AuthGoogleService googleAuth = getIt<AuthGoogleService>();

  // Google sign-in singleton init must complete before the router builds
  // (contract `contracts/google-signin-flow.md`, 7.x rules); guarded against
  // double-init inside the implementation.
  await googleAuth.initialize();

  // Restores a stored session (D3): unblocks the UI immediately when a valid
  // token exists, hydrating roles/`activeRole` in the background.
  await sessionCubit.initialize();

  final AppRouter appRouter = getIt<AppRouter>();

  runApp(
    ShopSpaceApp(
      localizationCubit: localizationCubit,
      router: appRouter.router,
      sessionCubit: sessionCubit,
    ),
  );
}

class ShopSpaceApp extends StatelessWidget {
  const ShopSpaceApp({
    super.key,
    required this.localizationCubit,
    required this.router,
    this.sessionCubit,
  });

  final LocalizationCubit localizationCubit;
  final GoRouter router;
  final AuthSessionCubit? sessionCubit;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocProvider.value(
        value: localizationCubit,
        child: BlocBuilder<LocalizationCubit, Locale>(
          builder: (context, locale) {
            Widget app = MaterialApp.router(
              title: 'ShopSpace',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.build(context),
              locale: locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              routerConfig: router,
            );
            if (sessionCubit != null) {
              app = BlocProvider.value(value: sessionCubit!, child: app);
            }
            return app;
          },
        ),
      ),
    );
  }
}

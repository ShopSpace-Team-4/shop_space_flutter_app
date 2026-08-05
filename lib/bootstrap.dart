import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injectable.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/localization_cubit.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final LocalizationCubit localizationCubit = getIt<LocalizationCubit>();
  final AppRouter appRouter = getIt<AppRouter>();

  runApp(
    ShopSpaceApp(
      localizationCubit: localizationCubit,
      router: appRouter.router,
    ),
  );
}

class ShopSpaceApp extends StatelessWidget {
  const ShopSpaceApp({
    super.key,
    required this.localizationCubit,
    required this.router,
  });

  final LocalizationCubit localizationCubit;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocProvider.value(
        value: localizationCubit,
        child: BlocBuilder<LocalizationCubit, Locale>(
          builder: (context, locale) => MaterialApp.router(
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
          ),
        ),
      ),
    );
  }
}

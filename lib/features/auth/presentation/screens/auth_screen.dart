import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_elevation.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../google/auth_google_service.dart';
import '../../repository/auth_repository.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/google_sign_in_cubit.dart';
import '../cubits/login_cubit.dart';
import '../cubits/signup_cubit.dart';
import '../widgets/login_form.dart';
import '../widgets/signup_form.dart';

/// Tabbed auth entry screen: a pill-styled Material [TabBar] (kept as the
/// Figma Sign In / Sign Up toggle) above a [TabBarView] holding the login and
/// signup forms. Both `/login` and `/signup` render this screen with a
/// different [initialIndex]; switching tabs is an in-screen operation, not a
/// route change. Each form scrolls independently and its cubits/controllers
/// stay alive across tab switches.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.initialIndex = 0});

  /// Which tab is active on first frame: 0 = sign in, 1 = sign up.
  final int initialIndex;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.xl.h),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicatorWeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    boxShadow: AppElevation.medium,
                  ),
                  labelColor: AppColors.textPrimary,
                  unselectedLabelColor: AppColors.textTertiary,
                  labelStyle: AppTypography.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: AppTypography.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  overlayColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  splashBorderRadius: BorderRadius.circular(AppRadius.pill),
                  onTap: (_) => FocusScope.of(context).unfocus(),
                  tabs: [
                    Tab(text: l10n.authLogin, height: 38.h),
                    Tab(text: l10n.authSignup, height: 38.h),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    BlocProvider(
                      create: (_) => LoginCubit(
                        repository: getIt<AuthRepository>(),
                        l10n: l10n,
                        session: getIt<AuthSessionCubit>(),
                      ),
                      child: BlocProvider(
                        create: (_) => GoogleSignInCubit(
                          googleAuth: getIt<AuthGoogleService>(),
                          session: getIt<AuthSessionCubit>(),
                          l10n: l10n,
                        ),
                        child: const LoginForm(),
                      ),
                    ),
                    BlocProvider(
                      create: (_) => SignupCubit(
                        repository: getIt<AuthRepository>(),
                        l10n: l10n,
                      ),
                      child: BlocProvider(
                        create: (_) => GoogleSignInCubit(
                          googleAuth: getIt<AuthGoogleService>(),
                          session: getIt<AuthSessionCubit>(),
                          l10n: l10n,
                        ),
                        child: const SignupForm(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

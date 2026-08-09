import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../data/models/user.dart';
import '../../repository/user_repository.dart';
import '../cubits/profile_cubit.dart';

/// Minimal account screen (T036, US6): shows the signed-in user's name and
/// email from [ProfileCubit], links to Change Password, and signs the user
/// out. The router's [AuthGuard] redirects to `/login` once the session is
/// cleared by [AuthSessionCubit.signOut]. Fully responsive (screenutil + flex).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubit _cubit;
  late final AuthSessionCubit _session;
  bool _signingOut = false;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _cubit = ProfileCubit(
      repository: getIt<UserRepository>(),
      l10n: AppLocalizations.of(context),
    );
    _session = getIt<AuthSessionCubit>();
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _signOut() {
    setState(() => _signingOut = true);
    _session.signOut();
  }

  String _fullName(User user) =>
      '${user.firstName} ${user.lastName}'.trim();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          bloc: _cubit,
          builder: (BuildContext context, ProfileState state) {
            final User? user = state.user;
            if (user != null) {
              return _ProfileContent(
                fullName: _fullName(user),
                email: user.email,
                phone: user.phone,
                signingOut: _signingOut,
                onSignOut: _signOut,
              );
            }
            if (state.errorMessage != null) {
              return _ProfileError(
                message: state.errorMessage!,
                onRetry: _cubit.load,
              );
            }
            return const AppLoadingView();
          },
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.signingOut,
    required this.onSignOut,
  });

  final String fullName;
  final String email;
  final String? phone;
  final bool signingOut;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 480.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.sm.h),
              Center(
                child: CircleAvatar(
                  radius: 40.r,
                  backgroundColor: AppColors.primaryContainer,
                  child: Icon(
                    Icons.person_outline,
                    size: 40.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Text(
                fullName,
                textAlign: TextAlign.center,
                style: AppTypography.heading2,
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                email,
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (phone != null && phone!.isNotEmpty) ...[
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  phone!,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              SizedBox(height: AppSpacing.xl.h),
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.storefront_outlined),
                      title: Text(l10n.myListingsTitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/my-listings'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.support_agent_outlined),
                      title: Text(l10n.navAdvisor),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/advisor'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: Text(l10n.profileChangePassword),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/change-password'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl.h),
              SizedBox(
                height: 48.h,
                child: OutlinedButton.icon(
                  onPressed: signingOut ? null : onSignOut,
                  icon: signingOut
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                  label: Text(l10n.profileSignOut),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge,
            ),
            SizedBox(height: AppSpacing.xl.h),
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}

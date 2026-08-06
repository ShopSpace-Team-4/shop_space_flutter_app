import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
/// cleared by [AuthSessionCubit.signOut].
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
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.sm),
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primaryContainer,
                  child: Icon(
                    Icons.person_outline,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                fullName,
                textAlign: TextAlign.center,
                style: AppTypography.heading2,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                email,
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (phone != null && phone!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  phone!,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: Text(l10n.profileChangePassword),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/change-password'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: signingOut ? null : onSignOut,
                  icon: signingOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
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
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.xl),
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

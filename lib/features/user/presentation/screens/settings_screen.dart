import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/localization_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/validation/form_validators.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../data/models/user.dart';
import '../cubits/profile_cubit.dart';
import '../widgets/edit_profile_sheet.dart';
import '../widgets/language_picker_sheet.dart';

/// Settings screen (US6, Figma `257:5684`): a lightweight, localized settings
/// surface reached from Profile. The Account card hosts Edit profile (shared
/// [EditProfileSheet]), Change password (`/change-password`) and Link Google
/// account; Notifications and Privacy cards are read-only placeholders and the
/// Delete account row is a destructive placeholder (no backend yet — flagged in
/// the plan). The back button is RTL-aware and uses `context.pop()` so deep
/// pushes from Profile keep a back affordance. Fully responsive.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final ProfileCubit _cubit;
  late final FormValidators _validators;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    // Shared session-scoped instance provided above the navigator (see
    // bootstrap.dart); the BlocProvider owns its lifecycle. Edit-profile /
    // link-google changes land on the SAME cubit ProfileScreen listens to, so
    // nothing is stale when navigating back.
    _cubit = context.read<ProfileCubit>();
    _validators = FormValidators(AppLocalizations.of(context));
  }

  void _onProfileState(BuildContext context, ProfileState state) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? message;
    if (state.linkSuccess) {
      message = l10n.profileLinkGoogleSuccess;
    } else if (state.linkError != null) {
      message = state.linkError;
    } else {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message!)));
    _cubit.clearLinkFeedback();
  }

  Future<void> _openEditProfile(User user) async {
    _cubit.clearUpdateFeedback();
    final bool? saved = await EditProfileSheet.show(
      context,
      cubit: _cubit,
      validators: _validators,
      user: user,
    );
    if (saved != true) return;
    _cubit.clearUpdateFeedback();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).profileEditSuccess)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg.w,
                AppSpacing.sm.h,
                AppSpacing.lg.w,
                AppSpacing.sm.h,
              ),
              child: Row(
                children: [
                  Material(
                    color: AppColors.surfaceVariant,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => context.pop(),
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: 32.r,
                        height: 32.r,
                        child: Icon(
                          isRtl ? Icons.arrow_forward : Icons.arrow_back,
                          size: 20.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: Text(
                      l10n.settingsTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<ProfileCubit, ProfileState>(
                bloc: _cubit,
                listener: _onProfileState,
                builder: (BuildContext context, ProfileState state) {
                  final User? user = state.user;
                  if (user == null) {
                    if (state.errorMessage != null) {
                      return _SettingsError(
                        message: state.errorMessage!,
                        onRetry: _cubit.load,
                      );
                    }
                    return const AppLoadingView();
                  }
                  return _SettingsBody(
                    user: user,
                    isLinking: state.isLinking,
                    onEditProfile: () => _openEditProfile(user),
                    onLinkGoogle: _cubit.linkGoogle,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({
    required this.user,
    required this.isLinking,
    required this.onEditProfile,
    required this.onLinkGoogle,
  });

  final User user;
  final bool isLinking;
  final VoidCallback onEditProfile;
  final VoidCallback onLinkGoogle;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String currentLanguage = context
            .select<LocalizationCubit, Locale>((cubit) => cubit.state)
            .languageCode ==
        'ar'
        ? l10n.settingsLanguageArabic
        : l10n.settingsLanguageEnglish;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl.w,
        AppSpacing.xs.h,
        AppSpacing.xl.w,
        AppSpacing.xl.h,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 560.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionLabel(l10n.settingsSectionAppearance),
              SizedBox(height: AppSpacing.sm.h),
              _Card(
                children: [
                  _SettingsRow(
                    icon: Icon(Icons.language, size: 20.sp),
                    title: l10n.settingsLanguage,
                    subtitle: currentLanguage,
                    onTap: () => LanguagePickerSheet.show(context),
                    trailing: const _Chevron(),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl.h),
              _SectionLabel(l10n.settingsSectionAccount),
              SizedBox(height: AppSpacing.sm.h),
              _Card(
                children: [
                  _SettingsRow(
                    icon: Icon(Icons.edit_outlined, size: 20.sp),
                    title: l10n.settingsEditProfile,
                    subtitle: l10n.settingsEditProfileSubtitle,
                    onTap: onEditProfile,
                  ),
                  const _Divider(),
                  _SettingsRow(
                    icon: Icon(Icons.lock_outline, size: 20.sp),
                    title: l10n.settingsChangePassword,
                    subtitle: l10n.settingsChangePasswordSubtitle,
                    onTap: () => context.push('/change-password'),
                  ),
                  const _Divider(),
                  _SettingsRow(
                    icon: SvgPicture.asset(
                      'assets/svgs/google_icon.svg',
                      width: 18.w,
                      height: 18.h,
                    ),
                    title: l10n.settingsLinkGoogle,
                    subtitle: l10n.settingsLinkGoogleSubtitle,
                    onTap: isLinking ? null : onLinkGoogle,
                    trailing: isLinking
                        ? _Spinner()
                        : const _Chevron(),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl.h),
              _SectionLabel(l10n.settingsSectionNotifications),
              SizedBox(height: AppSpacing.sm.h),
              _Card(
                children: [
                  _SettingsRow(
                    icon: Icon(Icons.notifications_none, size: 20.sp),
                    title: l10n.settingsNotifPush,
                    subtitle: l10n.settingsNotifPushSubtitle,
                    onTap: null,
                    trailing: const _DisabledSwitch(),
                  ),
                  const _Divider(),
                  _SettingsRow(
                    icon: Icon(Icons.email_outlined, size: 20.sp),
                    title: l10n.settingsNotifEmail,
                    subtitle: l10n.settingsNotifEmailSubtitle,
                    onTap: null,
                    trailing: const _DisabledSwitch(),
                  ),
                  const _Divider(),
                  _SettingsRow(
                    icon: Icon(Icons.sms_outlined, size: 20.sp),
                    title: l10n.settingsNotifSms,
                    subtitle: l10n.settingsNotifSmsSubtitle,
                    onTap: null,
                    trailing: const _DisabledSwitch(),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl.h),
              _SectionLabel(l10n.settingsSectionPrivacy),
              SizedBox(height: AppSpacing.sm.h),
              _Card(
                children: [
                  _SettingsRow(
                    icon: Icon(Icons.delete_outline, size: 20.sp),
                    title: l10n.settingsDeleteAccount,
                    subtitle: l10n.settingsDeleteAccountSubtitle,
                    onTap: null,
                    destructive: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.caption.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: AppColors.textTertiary,
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.h,
      thickness: 1,
      indent: AppSpacing.lg.w,
      endIndent: AppSpacing.lg.w,
      color: AppColors.outlineSubtle,
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.chevron_right, size: 14.sp, color: AppColors.textTertiary);
  }
}

class _Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14.r,
      height: 14.r,
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class _DisabledSwitch extends StatelessWidget {
  const _DisabledSwitch();

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: const IgnorePointer(
        child: Switch(
          value: false,
          onChanged: null,
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
    this.destructive = false,
  });

  final Widget icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final Color boxColor =
        destructive ? AppColors.errorContainer : AppColors.surfaceVariant;
    final Color iconColor =
        destructive ? AppColors.error : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(AppRadius.medium.r),
                ),
                child: Center(child: IconTheme.merge(data: IconThemeData(color: iconColor), child: icon)),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: destructive
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: AppSpacing.sm.w),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsError extends StatelessWidget {
  const _SettingsError({required this.message, required this.onRetry});

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
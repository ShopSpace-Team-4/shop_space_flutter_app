import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/validation/form_validators.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../auth/google/auth_google_service.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../../auth/presentation/widgets/labeled_input.dart';
import '../../data/models/user.dart';
import '../../repository/user_repository.dart';
import '../cubits/profile_cubit.dart';

/// Minimal account screen (T036, US6): shows the signed-in user's name and
/// email from [ProfileCubit], links to Change Password, links a Google
/// identity, and signs the user out. The router's [AuthGuard] redirects to
/// `/login` once the session is cleared by [AuthSessionCubit.signOut]. Fully
/// responsive (screenutil + flex).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubit _cubit;
  late final AuthSessionCubit _session;
  late final FormValidators _validators;
  bool _signingOut = false;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final AppLocalizations l10n = AppLocalizations.of(context);
    _cubit = ProfileCubit(
      repository: getIt<UserRepository>(),
      googleAuth: getIt<AuthGoogleService>(),
      l10n: l10n,
    );
    _validators = FormValidators(l10n);
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

  String _fullName(User user) =>
      '${user.firstName} ${user.lastName}'.trim();

  /// Converts the stored phone (E.164 `+20…` or local form) to the 11-digit
  /// local form the edit form validates and submits (D4).
  static String _localPhone(String phone) {
    final String digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11 && digits.startsWith('01')) return digits;
    if (digits.length == 13 && digits.startsWith('20')) {
      return digits.substring(2);
    }
    return phone;
  }

  /// Opens the edit-profile bottom sheet (prefilled from the current [User]).
  /// On success the sheet pops with `true` and this method shows the feedback
  /// SnackBar; the header already re-renders because the cubit stores the
  /// recached [User].
  Future<void> _openEditProfile(User user) async {
    _cubit.clearUpdateFeedback();
    final bool? saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _EditProfileSheet(
        cubit: _cubit,
        validators: _validators,
        user: user,
      ),
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          bloc: _cubit,
          listener: _onProfileState,
          builder: (BuildContext context, ProfileState state) {
            final User? user = state.user;
            if (user != null) {
              return _ProfileContent(
                fullName: _fullName(user),
                email: user.email,
                phone: user.phone,
                isLinking: state.isLinking,
                signingOut: _signingOut,
                onEditProfile: () => _openEditProfile(user),
                onLinkGoogle: _cubit.linkGoogle,
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
    required this.isLinking,
    required this.signingOut,
    required this.onEditProfile,
    required this.onLinkGoogle,
    required this.onSignOut,
  });

  final String fullName;
  final String email;
  final String? phone;
  final bool isLinking;
  final bool signingOut;
  final VoidCallback onEditProfile;
  final VoidCallback onLinkGoogle;
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
                      leading: const Icon(Icons.edit_outlined),
                      title: Text(l10n.profileEditProfile),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: onEditProfile,
                    ),
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
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets/svgs/google_icon.svg',
                        width: 24.w,
                        height: 24.h,
                      ),
                      title: Text(l10n.profileLinkGoogle),
                      trailing: isLinking
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child:
                                  const CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.chevron_right),
                      onTap: isLinking ? null : onLinkGoogle,
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

/// Edit-profile bottom sheet (profile → "Edit Profile"): a prefilled form for
/// first name / last name / phone, validated with the existing
/// [FormValidators]. Submitting calls [ProfileCubit.updateProfile]; the sheet
/// pops with `true` on success (inline error stays open for retry on failure).
/// Fully responsive (screenutil + flex).
class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({
    required this.cubit,
    required this.validators,
    required this.user,
  });

  final ProfileCubit cubit;
  final FormValidators validators;
  final User user;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: widget.user.firstName);
    _lastName = TextEditingController(text: widget.user.lastName);
    _phone = TextEditingController(
      text: _ProfileScreenState._localPhone(widget.user.phone),
    );
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    widget.cubit.updateProfile(
      firstName: _firstName.text,
      lastName: _lastName.text,
      phone: _phone.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg.w,
          0,
          AppSpacing.lg.w,
          AppSpacing.xl.h,
        ),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          bloc: widget.cubit,
          listener: (BuildContext context, ProfileState state) {
            if (!state.updateSuccess) return;
            // The sheet may have been dismissed mid-request; never pop a
            // route that isn't this sheet anymore.
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          },
          builder: (BuildContext context, ProfileState state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.profileEditTitle,
                    style: AppTypography.heading4.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LabeledInput(
                          label: l10n.authFirstNameLabel,
                          controller: _firstName,
                          validator: widget.validators.name,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        LabeledInput(
                          label: l10n.authLastNameLabel,
                          controller: _lastName,
                          validator: widget.validators.name,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        LabeledInput(
                          label: l10n.authPhoneLabel,
                          controller: _phone,
                          validator: widget.validators.phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                        ),
                      ],
                    ),
                  ),
                  if (state.updateError != null) ...[
                    SizedBox(height: AppSpacing.sm.h),
                    Text(
                      state.updateError!,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                  SizedBox(height: AppSpacing.lg.h),
                  SizedBox(
                    height: 48.h,
                    child: FilledButton(
                      onPressed: state.isUpdating ? null : _submit,
                      child: state.isUpdating
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onPrimary,
                              ),
                            )
                          : Text(l10n.profileEditSave),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/validation/form_validators.dart';
import '../../../auth/presentation/widgets/labeled_input.dart';
import '../cubits/change_password_cubit.dart';

/// Change-password screen (T037, US6) rebuilt to Figma frame `270:7286`.
/// On success the cubit clears the session (constitution §7 — never wait for a
/// 401) and this screen returns to `/login`; the button turns live-valid
/// against the five requirements bullets and the update is disabled while
/// submitting. Fully responsive (screenutil + flex).
///
/// Flagged gaps (no Figma state exists): success/loading frames absent —
/// success still routes straight to `/login` (existing behavior); the
/// "checked" bullet state and the button's active state are built with the
/// existing success/primary tokens.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  late final ChangePasswordCubit _cubit;
  late final FormValidators _validators;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final AppLocalizations l10n = AppLocalizations.of(context);
    _validators = FormValidators(l10n);
    // Provided by the router's BlocProvider; it owns this cubit's lifecycle.
    _cubit = context.read<ChangePasswordCubit>();
  }

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _cubit.submit(
      currentPassword: _currentPassword.text,
      newPassword: _newPassword.text,
    );
  }

  void _onState(BuildContext context, ChangePasswordState state) {
    if (!state.isSuccess) return;
    context.go('/login');
  }

  String? _currentPasswordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context).authCurrentPasswordRequired;
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n.authPasswordRequired;
    }
    if (value != _newPassword.text) {
      return l10n.authPasswordsDoNotMatch;
    }
    return null;
  }

  /// The five live requirements from the plan, in display order — mirrored to
  /// the backend zod rule (`_passwordPattern`).
  List<bool> _requirements(String value) {
    final RegExp lower = RegExp(r'[a-z]');
    final RegExp upper = RegExp(r'[A-Z]');
    final RegExp digit = RegExp(r'\d');
    final RegExp special = RegExp(r'[@$!%*?&]');
    return <bool>[
      value.length >= 8,
      lower.hasMatch(value),
      upper.hasMatch(value),
      digit.hasMatch(value),
      special.hasMatch(value),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleSpacing: 0,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: AppSpacing.lg.w),
                child: _CircularBackButton(onPressed: () => context.pop()),
              ),
            ),
            Text(l10n.changePasswordTitle),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg.w,
              AppSpacing.lg.h,
              AppSpacing.lg.w,
              AppSpacing.xxl.h,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 480.w),
              child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                bloc: _cubit,
                listener: _onState,
                builder: (BuildContext context, ChangePasswordState state) {
                  final List<bool> requirements = _requirements(
                    _newPassword.text,
                  );
                  final bool allRequirementsMet =
                      requirements.every((bool met) => met);
                  final bool liveValid =
                      _currentPassword.text.isNotEmpty &&
                      allRequirementsMet &&
                      _confirmPassword.text.isNotEmpty &&
                      _confirmPassword.text == _newPassword.text;

                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: AppSpacing.sm.h,
                            bottom: AppSpacing.xl.h,
                          ),
                          child: const Center(child: _HeroLockBlock()),
                        ),
                        LabeledInput(
                          label: l10n.authCurrentPasswordLabel,
                          controller: _currentPassword,
                          validator: _currentPasswordValidator,
                          obscureText: _obscureCurrent,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: _EyeToggle(
                            obscure: _obscureCurrent,
                            onPressed: () => setState(
                              () => _obscureCurrent = !_obscureCurrent,
                            ),
                          ),
                          autofillHints: const [AutofillHints.password],
                          onChanged: (_) => setState(() {}),
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        LabeledInput(
                          label: l10n.authNewPasswordLabel,
                          controller: _newPassword,
                          validator: _validators.password,
                          obscureText: _obscureNew,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: _EyeToggle(
                            obscure: _obscureNew,
                            onPressed: () => setState(
                              () => _obscureNew = !_obscureNew,
                            ),
                          ),
                          autofillHints: const [AutofillHints.newPassword],
                          onChanged: (_) => setState(() {}),
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        LabeledInput(
                          label: l10n.authConfirmPasswordLabel,
                          controller: _confirmPassword,
                          validator: _confirmPasswordValidator,
                          obscureText: _obscureConfirm,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: _EyeToggle(
                            obscure: _obscureConfirm,
                            onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                          autofillHints: const [AutofillHints.newPassword],
                          onChanged: (_) => setState(() {}),
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        if (state.errorMessage != null) ...[
                          SizedBox(height: AppSpacing.sm.h),
                          Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                        SizedBox(height: AppSpacing.lg.h),
                        _RequirementsCard(
                          requirements: requirements,
                          labels: <String>[
                            l10n.changePasswordRequirementLength,
                            l10n.changePasswordRequirementLowercase,
                            l10n.changePasswordRequirementUppercase,
                            l10n.changePasswordRequirementNumber,
                            l10n.changePasswordRequirementSpecial,
                          ],
                        ),
                        SizedBox(height: AppSpacing.xl.h),
                        SizedBox(
                          height: 56.h,
                          child: FilledButton(
                            onPressed: (state.isSubmitting || !liveValid)
                                ? null
                                : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              disabledBackgroundColor:
                                  AppColors.textDisabled,
                              disabledForegroundColor: AppColors.onPrimary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.large.r,
                                ),
                              ),
                            ),
                            child: state.isSubmitting
                                ? SizedBox(
                                    width: 22.w,
                                    height: 22.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.changePasswordSubmit),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular 32×32 back button (Figma `270:7294`): fill `surfaceVariant`, `16`
/// radius, `arrow_back` (auto-mirrors in RTL, Figma `270:7291` app bar).
class _CircularBackButton extends StatelessWidget {
  const _CircularBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceVariant,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 32.r,
          height: 32.r,
          child: Icon(
            Icons.arrow_back,
            size: 20.sp,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Hero lock block (Figma `270:7298` → `270:7299`): 72×72, `20` radius,
/// linear gradient `primaryContainer → lockGradientEnd`, `primaryBorder`
/// stroke, blue drop-shadow (blur 20 / rgba(37,99,235,.12) at y+6), and a
/// 32×32 `lock_outline` in primary.
class _HeroLockBlock extends StatelessWidget {
  const _HeroLockBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.r,
      height: 72.r,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.primaryContainer,
            AppColors.lockGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.hero.r),
        border: Border.all(color: AppColors.primaryBorder),
        boxShadow: const <BoxShadow>[
          // Figma-exact drop shadow — blur/elevation are the deliberate
          // constants exception (constitution §4).
          BoxShadow(
            color: Color(0x1F2563EB), // rgba(37,99,235,0.12)
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        Icons.lock_outline,
        size: 32.r,
        color: AppColors.primary,
      ),
    );
  }
}

/// Inline eye toggle reusing the previous `IconButton` suffix-icon pattern.
class _EyeToggle extends StatelessWidget {
  const _EyeToggle({required this.obscure, required this.onPressed});

  final bool obscure;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        obscure
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
      ),
      onPressed: onPressed,
    );
  }
}

/// Requirements card (Figma `270:7325` → `270:7326`): fill `background`,
/// `12` radius, `outline` stroke; caption-u600 `textMuted` title and five
/// 16×16 rounded-8 bullets — unchecked `outline`, checked `success` + white
/// check, text flips `textTertiary → textPrimary`.
class _RequirementsCard extends StatelessWidget {
  const _RequirementsCard({required this.requirements, required this.labels});

  final List<bool> requirements;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w - 2.w,
        AppSpacing.md.h,
        AppSpacing.lg.w - 2.w,
        AppSpacing.md.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.changePasswordRequirements,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.55,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          for (int i = 0; i < requirements.length; i++) ...[
            _RequirementRow(
              checked: requirements[i],
              label: labels[i],
            ),
            if (i != requirements.length - 1) SizedBox(height: AppSpacing.sm.h),
          ],
        ],
      ),
    );
  }
}

/// Single 16×16 rounded-8 requirement bullet with label.
class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.checked, required this.label});

  final bool checked;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 16.r,
          height: 16.r,
          decoration: BoxDecoration(
            color: checked ? AppColors.success : AppColors.outline,
            borderRadius: BorderRadius.circular(AppRadius.field.r),
          ),
          child: checked
              ? const Icon(
                  Icons.check,
                  size: 12,
                  color: AppColors.onPrimary,
                )
              : null,
        ),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 14.sp,
              color: checked ? AppColors.textPrimary : AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
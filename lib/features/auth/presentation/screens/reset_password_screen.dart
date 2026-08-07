import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/validation/form_validators.dart';
import '../../repository/auth_repository.dart';
import '../cubits/otp_cubit.dart';
import '../cubits/reset_password_cubit.dart';
import '../widgets/labeled_input.dart';
import '../widgets/otp_input.dart';

/// Reset-password screen (T030). Reads the email from the route query param
/// (graceful if missing), shows a prefilled read-only email, an [OtpInput]
/// with cooldown/resend driven by the reused [OtpCubit], and a new-password
/// field (Q2); success goes to `/login`.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.email});

  final String? email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PinInputController _otpController = PinInputController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final String _email;
  ResetPasswordCubit? _cubit;
  late final FormValidators _validators;
  Timer? _countdownTimer;
  int _secondsRemaining = 0;
  bool _obscurePassword = true;
  bool _showSuccess = false;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _email = (widget.email ?? '').trim();
    _emailController.text = _email;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final AppLocalizations l10n = AppLocalizations.of(context);
    _validators = FormValidators(l10n);
    if (_email.isNotEmpty) {
      _cubit = ResetPasswordCubit(
        repository: getIt<AuthRepository>(),
        l10n: l10n,
        email: _email,
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _otpController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cubit?.close();
    super.dispose();
  }

  void _onState(BuildContext context, ResetPasswordState state) {
    if (state.isSuccess) {
      _onSuccess();
      return;
    }
    _syncCountdown(state);
  }

  void _onSuccess() {
    _countdownTimer?.cancel();
    _otpController.clear();
    if (!mounted) return;
    setState(() => _showSuccess = true);
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      context.go('/login');
    });
  }

  void _syncCountdown(ResetPasswordState state) {
    final DateTime? until = state.resendCooldownUntil;
    if (until == null) {
      _countdownTimer?.cancel();
      _secondsRemaining = 0;
      return;
    }
    final int remaining = until.difference(DateTime.now()).inSeconds;
    if (remaining <= 0) {
      _countdownTimer?.cancel();
      _secondsRemaining = 0;
      return;
    }
    if (_countdownTimer == null || !_countdownTimer!.isActive) {
      _secondsRemaining = remaining;
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        final int left = until.difference(DateTime.now()).inSeconds;
        if (!mounted) {
          _countdownTimer?.cancel();
          return;
        }
        setState(() => _secondsRemaining = left <= 0 ? 0 : left);
        if (left <= 0) _countdownTimer!.cancel();
      });
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _cubit?.submit(
      otp: _otpController.text,
      newPassword: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (_email.isEmpty || _cubit == null) {
      return _buildMissingEmail(l10n);
    }
    return _buildResetScreen(l10n);
  }

  Widget _buildMissingEmail(AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.authResetPassword)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.errorValidation,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => context.go('/login'),
                child: Text(l10n.authBackToLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResetScreen(AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.authResetPassword)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                bloc: _cubit,
                listener: _onState,
                builder: (BuildContext context, ResetPasswordState state) {
                  if (_showSuccess) {
                    return _buildSuccess(l10n);
                  }
                  return _buildForm(l10n, state);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_outline,
            size: 48, color: AppColors.success),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.authResetPasswordSuccess,
          textAlign: TextAlign.center,
          style: AppTypography.heading4,
        ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton(
          onPressed: () => context.go('/login'),
          child: Text(l10n.authLoginSubmit),
        ),
      ],
    );
  }

  Widget _buildForm(AppLocalizations l10n, ResetPasswordState state) {
    final bool locked = state.isLocked;
    final bool coolingDown =
        (_cubit?.isCoolingDown ?? false) || _secondsRemaining > 0;
    final String otp = _otpController.text;
    final bool canSubmit =
        otp.length == OtpInput.length && !state.isSubmitting && !locked;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.authResetPasswordTitle, style: AppTypography.heading2),
          const SizedBox(height: AppSpacing.xl),
          LabeledInput(
            label: l10n.authEmailLabel,
            controller: _emailController,
            readOnly: true,
            prefixIcon: Icons.alternate_email_outlined,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.lg),
          OtpInput(
            controller: _otpController,
            semanticsLabel: l10n.authOtpFieldSemanticLabel,
            enabled: !locked && !state.isSubmitting,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (canSubmit) _submit();
            },
          ),
          const SizedBox(height: AppSpacing.md),
          if (locked)
            Text(
              l10n.authOtpLocked,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
            )
          else if (state.attemptsRemaining < OtpCubit.maxAttempts)
            Text(
              l10n.authOtpAttemptsRemaining(state.attemptsRemaining),
              textAlign: TextAlign.center,
              style:
                  AppTypography.caption.copyWith(color: AppColors.textSecondary),
            ),
          const SizedBox(height: AppSpacing.lg),
          LabeledInput(
            label: l10n.authNewPasswordLabel,
            controller: _passwordController,
            validator: _validators.password,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () => setState(
                () => _obscurePassword = !_obscurePassword,
              ),
            ),
            autofillHints: const [AutofillHints.newPassword],
            onFieldSubmitted: (_) {
              if (canSubmit) _submit();
            },
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: canSubmit ? _submit : null,
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.authResetPasswordSubmit),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.isResending)
            const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (coolingDown && !locked)
            Center(
              child: Text(
                l10n.authOtpResendIn(_secondsRemaining),
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
            )
          else if (locked)
            Center(
              child: TextButton(
                onPressed: coolingDown ? null : _cubit?.resend,
                child: Text(l10n.authOtpRequestNewCode),
              ),
            )
          else
            Center(
              child: TextButton(
                onPressed: _cubit?.resend,
                child: Text(l10n.authOtpResend),
              ),
            ),
        ],
      ),
    );
  }
}

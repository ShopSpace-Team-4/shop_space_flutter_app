import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../repository/auth_repository.dart';
import '../cubits/otp_cubit.dart';
import '../widgets/otp_input.dart';

/// OTP verification screen (T015). Reads the target email from the route's
/// `email` query param; a missing value renders a graceful fallback. Success
/// shows a confirmation panel and returns to sign-in (never auto-login).
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, this.email});

  final String? email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();

  late final String _email;
  OtpCubit? _cubit;
  Timer? _countdownTimer;
  int _secondsRemaining = 0;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _email = (widget.email ?? '').trim();
    if (_email.isNotEmpty) {
      _cubit = OtpCubit(
        repository: getIt<AuthRepository>(),
        email: _email,
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _codeController.dispose();
    _codeFocusNode.dispose();
    _cubit?.close();
    super.dispose();
  }

  void _onState(BuildContext context, OtpState state) {
    if (state.verified) {
      _onVerified();
      return;
    }
    _syncCountdown(state);
  }

  void _onVerified() {
    _countdownTimer?.cancel();
    _codeController.clear();
    if (!mounted) return;
    setState(() => _showSuccess = true);
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      context.go('/login');
    });
  }

  void _syncCountdown(OtpState state) {
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

  void _verify() {
    FocusScope.of(context).unfocus();
    _cubit?.verify(_codeController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (_email.isEmpty || _cubit == null) {
      return _buildMissingEmail(l10n);
    }
    return _buildOtpScreen(l10n);
  }

  Widget _buildMissingEmail(AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.authOtp)),
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

  Widget _buildOtpScreen(AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.authOtp)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: BlocConsumer<OtpCubit, OtpState>(
                bloc: _cubit,
                listener: _onState,
                builder: (BuildContext context, OtpState state) {
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
          l10n.authOtpSuccess,
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

  Widget _buildForm(AppLocalizations l10n, OtpState state) {
    final bool locked = state.isLocked;
    final bool coolingDown =
        (_cubit?.isCoolingDown ?? false) || _secondsRemaining > 0;
    final String code = _codeController.text;
    final bool canVerify =
        code.length == OtpInput.length && !state.isSubmitting && !locked;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.authOtpTitle, style: AppTypography.heading2),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.authOtpSubtitle(_email),
          style:
              AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        OtpInput(
          controller: _codeController,
          focusNode: _codeFocusNode,
          semanticsLabel: l10n.authOtpFieldSemanticLabel,
          enabled: !locked && !state.isSubmitting,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) {
            if (canVerify) _verify();
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
        if (state.failure != null && !locked) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            failureMessage(l10n, state.failure!),
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: canVerify ? _verify : null,
            child: state.isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.authOtpVerifySubmit),
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
    );
  }
}

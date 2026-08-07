import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../repository/auth_repository.dart';
import '../cubits/otp_cubit.dart';
import '../widgets/otp_input.dart';

/// OTP verification screen (T015, Figma 242:723). Reads the target email from
/// the route's `email` query param; a missing value renders a graceful
/// fallback. Success shows a confirmation panel and returns to sign-in (never
/// auto-login). The layout adapts the WhatsApp mockup to an email theme using
/// existing tokens.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, this.email});

  final String? email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final PinInputController _codeController = PinInputController();

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
      _cubit = OtpCubit(repository: getIt<AuthRepository>(), email: _email);
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _codeController.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.errorValidation,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => context.go('/login'),
              child: Text(l10n.authBackToLogin),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpScreen(AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg.h),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: BlocConsumer<OtpCubit, OtpState>(
              bloc: _cubit,
              listener: _onState,
              builder: (BuildContext context, OtpState state) {
                if (_showSuccess) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(l10n),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildSuccess(l10n),
                    ],
                  );
                }
                return _buildForm(l10n, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      height: 44.h,
      child: Row(
        children: [
          Material(
            color: AppColors.surfaceVariant,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.pop(),
              child: SizedBox(
                width: 32.w,
                height: 32.h,
                child: Icon(
                  isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
                  size: 14.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              l10n.authOtpTitle,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 32.w),
        ],
      ),
    );
  }

  Widget _buildSuccess(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_outline, size: 48.sp, color: AppColors.success),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.authOtpSuccess,
          textAlign: TextAlign.center,
          style: AppTypography.heading4.copyWith(fontSize: 20.sp),
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
        _buildHeader(l10n),
        const SizedBox(height: AppSpacing.lg),
        _buildEmailImage(),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.authOtpEnterCode,
          textAlign: TextAlign.center,
          style: AppTypography.heading4.copyWith(
            fontSize: 20.sp,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.authOtpSubtitle(_email),
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 14.sp,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildResendRow(l10n, state, coolingDown, locked),
        const SizedBox(height: AppSpacing.lg),
        OtpInput(
          controller: _codeController,
          semanticsLabel: l10n.authOtpFieldSemanticLabel,
          enabled: !locked && !state.isSubmitting,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) {
            if (canVerify) _verify();
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildHint(l10n),
        if (locked) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.authOtpLocked,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 14.sp,
              color: AppColors.error,
            ),
          ),
        ] else if (state.attemptsRemaining < OtpCubit.maxAttempts) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.authOtpAttemptsRemaining(state.attemptsRemaining),
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
        if (state.failure != null && !locked) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            failureMessage(l10n, state.failure!),
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 14.sp,
              color: AppColors.error,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        _buildVerifyButton(l10n, state, canVerify),
      ],
    );
  }

  Widget _buildEmailImage() {
    return Center(
      child: Container(
        width: 96.w,
        height: 96.h,
        decoration: const BoxDecoration(
          color: AppColors.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Image.asset('assets/pngs/gmail.png', fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildResendRow(
    AppLocalizations l10n,
    OtpState state,
    bool coolingDown,
    bool locked,
  ) {
    if (state.isResending) {
      return Center(
        child: SizedBox(
          width: 22.w,
          height: 22.h,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (locked) {
      return Center(
        child: TextButton(
          onPressed: coolingDown ? null : _cubit?.resend,
          child: Text(l10n.authOtpRequestNewCode),
        ),
      );
    }
    if (coolingDown) {
      return Center(
        child: Text(
          l10n.authOtpResendIn(_secondsRemaining),
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }
    return Center(
      child: TextButton(
        onPressed: _cubit?.resend,
        child: Text(l10n.authOtpResend),
      ),
    );
  }

  Widget _buildHint(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.successContainer,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        children: [
          Icon(
            Icons.mark_email_read_outlined,
            size: 18.sp,
            color: AppColors.successOnContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              l10n.authOtpEmailHint,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14.sp,
                color: AppColors.successOnContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton(
    AppLocalizations l10n,
    OtpState state,
    bool canVerify,
  ) {
    final bool submitting = state.isSubmitting;
    return SizedBox(
      height: 56.h,
      child: FilledButton(
        onPressed: submitting ? null : (canVerify ? _verify : null),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: submitting
              ? AppColors.primary
              : AppColors.outline,
          disabledForegroundColor: submitting
              ? AppColors.onPrimary
              : AppColors.textTertiary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
        ),
        child: submitting
            ? SizedBox(
                width: 22.w,
                height: 22.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : Text(
                l10n.authOtpVerifySubmit,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

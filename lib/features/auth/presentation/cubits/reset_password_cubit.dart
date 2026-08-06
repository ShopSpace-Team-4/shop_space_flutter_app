import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/models/reset_password_request.dart';
import '../../repository/auth_repository.dart';
import 'otp_cubit.dart';

part 'reset_password_cubit.freezed.dart';

@freezed
abstract class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    String? errorMessage,
    @Default(OtpCubit.maxAttempts) int attemptsRemaining,
    DateTime? resendCooldownUntil,
    @Default(false) bool isResending,
  }) = _ResetPasswordState;

  const ResetPasswordState._();

  bool get isLocked => attemptsRemaining == 0;
}

/// Reset-password flow (T028). Reuses the [OtpCubit] state machine (T010) for
/// attempts/cooldown/resend; submitting sends the OTP + new password (Q2) to
/// `AuthRepository.resetPassword`, and success navigates to `/login`.
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({
    required AuthRepository repository,
    required AppLocalizations l10n,
    required String email,
    DateTime Function()? now,
  })  : _repository = repository,
        _l10n = l10n,
        _email = email,
        otpCubit = OtpCubit(repository: repository, email: email, now: now),
        super(const ResetPasswordState()) {
    _subscription = otpCubit.stream.listen(_onOtpState);
  }

  final AuthRepository _repository;
  final AppLocalizations _l10n;
  final String _email;
  late final StreamSubscription<OtpState> _subscription;

  /// The reused OTP state machine (T010) — attempts, cooldown, resend.
  final OtpCubit otpCubit;

  bool get isCoolingDown => otpCubit.isCoolingDown;

  void _onOtpState(OtpState otp) {
    emit(state.copyWith(
      attemptsRemaining: otp.attemptsRemaining,
      resendCooldownUntil: otp.resendCooldownUntil,
      isResending: otp.isResending,
    ));
  }

  Future<void> resend() => otpCubit.resend();

  Future<void> submit({required String otp, required String newPassword}) async {
    if (state.isSubmitting || state.isLocked || state.isSuccess) return;
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      await _repository.resetPassword(
        ResetPasswordRequest(
          email: _email,
          otpCode: otp.trim(),
          newPassword: newPassword,
        ),
      );
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } on InvalidOtp catch (failure) {
      emit(state.copyWith(
        isSubmitting: false,
        attemptsRemaining: state.attemptsRemaining - 1,
        errorMessage: failureMessage(_l10n, failure),
      ));
    } on OtpAttemptsExceeded catch (failure) {
      emit(state.copyWith(
        isSubmitting: false,
        attemptsRemaining: 0,
        errorMessage: failureMessage(_l10n, failure),
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failureMessage(_l10n, failure),
      ));
    } catch (_) {
      emit(state.copyWith(isSubmitting: false, errorMessage: _l10n.errorServer));
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await otpCubit.close();
    await super.close();
  }
}

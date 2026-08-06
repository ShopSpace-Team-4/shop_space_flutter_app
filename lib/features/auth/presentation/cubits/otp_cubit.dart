import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/otp_verification_request.dart';
import '../../data/models/resend_otp_request.dart';
import '../../repository/auth_repository.dart';

/// OTP domain state (`specs/002-auth-verification-roles/data-model.md` §1.3).
/// The Cubit owns truth; the widget owns only the 1s countdown `Timer`.
class OtpState {
  const OtpState({
    this.isSubmitting = false,
    this.isResending = false,
    this.resendCooldownUntil,
    this.attemptsRemaining = OtpCubit.maxAttempts,
    this.failure,
    this.verified = false,
  });

  final bool isSubmitting;
  final bool isResending;

  /// Absolute time (set to `now + 60s`) after which a resend is allowed again.
  /// Never a relative count — the widget derives "seconds remaining" from it.
  final DateTime? resendCooldownUntil;

  /// Starts at 5; only an invalid-code response decrements it (Q4).
  final int attemptsRemaining;

  final Failure? failure;

  /// Set when the code verified successfully — the signal the screen uses to
  /// navigate (contract `otp-validation.md`).
  final bool verified;

  bool get isLocked => attemptsRemaining == 0;

  OtpState copyWith({
    bool? isSubmitting,
    bool? isResending,
    DateTime? resendCooldownUntil,
    int? attemptsRemaining,
    Failure? failure,
    bool? verified,
    bool clearFailure = false,
  }) {
    return OtpState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isResending: isResending ?? this.isResending,
      resendCooldownUntil: resendCooldownUntil ?? this.resendCooldownUntil,
      attemptsRemaining: attemptsRemaining ?? this.attemptsRemaining,
      failure: clearFailure ? null : failure ?? this.failure,
      verified: verified ?? this.verified,
    );
  }
}

/// OTP verification flow (`contracts/otp-validation.md`): 5-attempt cap, 60s
/// resend cooldown, no attempt deducted on transport errors, `isLocked` at 0.
class OtpCubit extends Cubit<OtpState> {
  OtpCubit({
    required AuthRepository repository,
    required String email,
    DateTime Function()? now,
  })  : _repository = repository,
        _email = email,
        _now = now ?? DateTime.now,
        super(const OtpState());

  static const int maxAttempts = 5;
  static const Duration resendCooldown = Duration(seconds: 60);

  final AuthRepository _repository;
  final String _email;
  final DateTime Function() _now;

  /// Resend is blocked while `now` is inside the cooldown window.
  bool get isCoolingDown =>
      state.resendCooldownUntil?.isAfter(_now()) ?? false;

  Future<void> verify(String otp) async {
    if (state.isLocked || state.isSubmitting || state.verified) {
      return;
    }
    emit(state.copyWith(isSubmitting: true, failure: null));
    try {
      await _repository.verifyOtp(
        OtpVerificationRequest(email: _email, otpCode: otp),
      );
      emit(state.copyWith(isSubmitting: false, verified: true));
    } on InvalidOtp catch (failure) {
      emit(state.copyWith(
        isSubmitting: false,
        attemptsRemaining: state.attemptsRemaining - 1,
        failure: failure,
      ));
    } on OtpAttemptsExceeded catch (failure) {
      emit(state.copyWith(
        isSubmitting: false,
        attemptsRemaining: 0,
        failure: failure,
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(isSubmitting: false, failure: failure));
    }
  }

  Future<void> resend() async {
    if (state.isResending || isCoolingDown) {
      return;
    }
    emit(state.copyWith(isResending: true, failure: null));
    try {
      await _repository.resendOtp(ResendOtpRequest(email: _email));
      emit(state.copyWith(
        isResending: false,
        attemptsRemaining: maxAttempts,
        resendCooldownUntil: _now().add(resendCooldown),
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(isResending: false, failure: failure));
    }
  }
}

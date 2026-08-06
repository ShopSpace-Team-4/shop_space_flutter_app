import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/validation/form_validators.dart';
import '../../data/models/signup_request.dart';
import '../../repository/auth_repository.dart';

part 'signup_cubit.freezed.dart';

@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _SignupState;
}

/// Signup form state (T012). [isSuccess] navigates to OTP verification.
class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required AuthRepository repository,
    required AppLocalizations l10n,
  })  : _repository = repository,
        _l10n = l10n,
        super(const SignupState());

  final AuthRepository _repository;
  final AppLocalizations _l10n;

  void submit({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) {
    if (state.isSubmitting) return;
    final String? normalizedPhone =
        FormValidators.normalizePhone(phone.replaceAll(RegExp(r'\D'), ''));
    _signup(
      SignupRequest(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: email.trim(),
        phone: normalizedPhone ?? phone,
        password: password,
      ),
    );
  }

  Future<void> _signup(SignupRequest request) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      await _repository.signup(request);
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } on Failure catch (failure) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failureMessage(_l10n, failure),
      ));
    } catch (_) {
      emit(state.copyWith(isSubmitting: false, errorMessage: _l10n.errorServer));
    }
  }
}

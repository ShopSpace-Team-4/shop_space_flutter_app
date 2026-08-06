import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/models/forgot_password_request.dart';
import '../../repository/auth_repository.dart';

part 'forgot_password_cubit.freezed.dart';

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _ForgotPasswordState;
}

/// Forgot-password form state (T027). [isSuccess] shows the confirmation copy
/// and routes to `/reset-password?email=<email>`.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({
    required AuthRepository repository,
    required AppLocalizations l10n,
  })  : _repository = repository,
        _l10n = l10n,
        super(const ForgotPasswordState());

  final AuthRepository _repository;
  final AppLocalizations _l10n;

  Future<void> submit({required String email}) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      await _repository.forgotPassword(
        ForgotPasswordRequest(email: email.trim()),
      );
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

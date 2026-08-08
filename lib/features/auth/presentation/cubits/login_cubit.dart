import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/models/auth_tokens.dart' as feature;
import '../../data/models/login_request.dart';
import '../../repository/auth_repository.dart';
import 'auth_session_cubit.dart';

part 'login_cubit.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    String? errorMessage,
    /// Populated when login is rejected because the account isn't verified;
    /// the form redirects to OTP verification for this email.
    String? verificationEmail,
  }) = _LoginState;
}

/// Login form state (T018). On success the token pair is handed to
/// [AuthSessionCubit] to persist and establish the session.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthRepository repository,
    required AppLocalizations l10n,
    required AuthSessionCubit session,
  })  : _repository = repository,
        _l10n = l10n,
        _session = session,
        super(const LoginState());

  final AuthRepository _repository;
  final AppLocalizations _l10n;
  final AuthSessionCubit _session;

  Future<void> submit({required String email, required String password}) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(
      isSubmitting: true,
      errorMessage: null,
      verificationEmail: null,
    ));
    try {
      final feature.AuthTokens tokens = await _repository.login(
        LoginRequest(email: email.trim(), password: password),
      );
      await _session.authenticate(
        AuthTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        ),
      );
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } on EmailNotVerified {
      emit(state.copyWith(
        isSubmitting: false,
        verificationEmail: email.trim(),
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
}

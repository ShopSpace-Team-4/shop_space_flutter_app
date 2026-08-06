import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/models/auth_tokens.dart' as feature;
import '../../google/auth_google_service.dart';
import 'auth_session_cubit.dart';

part 'google_sign_in_cubit.freezed.dart';

@freezed
abstract class GoogleSignInState with _$GoogleSignInState {
  const factory GoogleSignInState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _GoogleSignInState;
}

/// Google sign-in form state (T023, US4). On success the token pair is handed
/// to [AuthSessionCubit] to persist and establish the session, mirroring
/// [LoginCubit].
class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  GoogleSignInCubit({
    required AuthGoogleService googleAuth,
    required AuthSessionCubit session,
    required AppLocalizations l10n,
  })  : _googleAuth = googleAuth,
        _session = session,
        _l10n = l10n,
        super(const GoogleSignInState());

  final AuthGoogleService _googleAuth;
  final AuthSessionCubit _session;
  final AppLocalizations _l10n;

  Future<void> signInWithGoogle() async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      final feature.AuthTokens tokens = await _googleAuth.signInAndGetTokens();
      await _session.authenticate(
        AuthTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        ),
      );
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } on GoogleSignInCancelled {
      // Dismissed Google sheet: stay on the current screen, no error toast
      // (contract `contracts/google-signin-flow.md`).
      emit(state.copyWith(isSubmitting: false));
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

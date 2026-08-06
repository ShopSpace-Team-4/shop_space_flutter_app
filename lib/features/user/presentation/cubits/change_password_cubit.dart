import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../repository/user_repository.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';

part 'change_password_cubit.freezed.dart';

@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _ChangePasswordState;
}

/// Change-password form state (T035, US6). On success the session is cleared
/// via [AuthSessionCubit.clearSession] (FR-013 — the single session-clearing
/// mechanism) so the user is routed straight to `/login`, never waiting for a
/// 401 (constitution §6).
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({
    required UserRepository repository,
    required AuthSessionCubit session,
    required AppLocalizations l10n,
  })  : _repository = repository,
        _session = session,
        _l10n = l10n,
        super(const ChangePasswordState());

  final UserRepository _repository;
  final AuthSessionCubit _session;
  final AppLocalizations _l10n;

  Future<void> submit({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _session.clearSession();
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

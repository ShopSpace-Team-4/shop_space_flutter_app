import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/models/user.dart';
import '../../repository/user_repository.dart';

part 'profile_cubit.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    User? user,
    String? errorMessage,
  }) = _ProfileState;
}

/// Minimal account-screen data loader (T034, US6). Fetches the signed-in
/// user's profile (name/email/phone) via `UserRepository.getProfile()` and
/// exposes loading/loaded/error states. Deliberately small — profile editing
/// is a later phase.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required UserRepository repository,
    required AppLocalizations l10n,
  })  : _repository = repository,
        _l10n = l10n,
        super(const ProfileState());

  final UserRepository _repository;
  final AppLocalizations _l10n;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final User user = await _repository.getProfile();
      emit(ProfileState(isLoading: false, user: user));
    } on Failure catch (failure) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: failureMessage(_l10n, failure),
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false, errorMessage: _l10n.errorServer));
    }
  }
}

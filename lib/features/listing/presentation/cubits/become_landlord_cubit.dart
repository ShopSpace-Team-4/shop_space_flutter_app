import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/storage/preferences_service.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../../user/data/models/user.dart';
import '../../../user/data/models/user_role.dart';
import '../../../user/repository/user_repository.dart';

part 'become_landlord_cubit.freezed.dart';

@freezed
abstract class BecomeLandlordState with _$BecomeLandlordState {
  const factory BecomeLandlordState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    Failure? failure,
  }) = _BecomeLandlordState;
}

/// In-flow "Become a Landlord" (US1/T038, contract `become-landlord-flow.md`).
///
/// Reuses the injected Phase 1 seam — `UserRepository.addRole` +
/// `switchActiveRole` — and NEVER re-implements role upgrade or token
/// rotation (the fresh token pair is written by `addRole` via
/// `SessionController.onTokensUpdated` before this method returns).
///
/// - On success the updated `roles[]` is reflected on [AuthSessionCubit] so
///   guards and permission-sensitive UI (FR-013) re-evaluate.
/// - `switchActiveRole(landlord)` is best-effort: a failure is NON-blocking
///   because permissions come from `roles[]`, not `activeRole` (D7).
class BecomeLandlordCubit extends Cubit<BecomeLandlordState> {
  BecomeLandlordCubit({
    required UserRepository repository,
    required AuthSessionCubit session,
    required PreferencesService preferences,
  })  : _repository = repository,
        _session = session,
        _preferences = preferences,
        super(const BecomeLandlordState());

  /// `shared_preferences` key for the last-used dashboard (roles-session.md).
  static const String activeRoleKey = 'activeRole';

  final UserRepository _repository;
  final AuthSessionCubit _session;
  final PreferencesService _preferences;

  Future<void> becomeLandlord() async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, failure: null, isSuccess: false));
    try {
      final User user = await _repository.addRole(UserRole.landlord);
      _session.updateRoles(user.roles.map((UserRole role) => role.name).toSet());
      // Best-effort dashboard switch — a failure never blocks the create flow
      // (permissions come from roles[], FR-013 / D7).
      try {
        final User switched = await _repository.switchActiveRole(UserRole.landlord);
        await _preferences.setString(activeRoleKey, switched.activeRole.name);
        _session.updateActiveRole(switched.activeRole);
      } catch (_) {
        // Non-blocking: keep the successful role upgrade.
      }
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } on Failure catch (failure) {
      emit(state.copyWith(isSubmitting: false, failure: failure));
    } catch (_) {
      emit(state.copyWith(isSubmitting: false, failure: const ServerFailure('')));
    }
  }
}

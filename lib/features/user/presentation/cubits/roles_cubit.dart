import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/storage/preferences_service.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../data/models/user.dart';
import '../../data/models/user_role.dart';
import '../../repository/user_repository.dart';

part 'roles_cubit.freezed.dart';

@freezed
abstract class RolesState with _$RolesState {
  const factory RolesState({
    @Default(false) bool isAddingRole,
    @Default(false) bool isSwitchingRole,
    @Default(false) bool isSuccess,
    User? user,
    String? errorMessage,
  }) = _RolesState;
}

/// Shared account/role-management capability (T032, US5). No screen triggers
/// it in Phase 1; later phases (become landlord, role switch surface) construct
/// this cubit. It is the only owner of role-mutation calls, so cross-feature
/// reuse injects the same [UserRepository] (constitution §2).
///
/// - [addRole] reflects the updated `roles[]` on [AuthSessionCubit] so guards
///   re-evaluate. The fresh token pair from `addRole` is written INSIDE
///   [UserRepository] before this method returns (constitution §6).
/// - [switchActiveRole] persists the last-used dashboard to
///   `shared_preferences` (key [activeRoleKey]) and reflects it on the session.
class RolesCubit extends Cubit<RolesState> {
  RolesCubit({
    required UserRepository repository,
    required AuthSessionCubit session,
    required PreferencesService preferences,
    required AppLocalizations l10n,
  })  : _repository = repository,
        _session = session,
        _preferences = preferences,
        _l10n = l10n,
        super(const RolesState());

  /// `shared_preferences` key for the last-used dashboard (role-session.md).
  static const String activeRoleKey = 'activeRole';

  final UserRepository _repository;
  final AuthSessionCubit _session;
  final PreferencesService _preferences;
  final AppLocalizations _l10n;

  /// Adds a role and reflects the updated set on the session. The returned
  /// [User] carries the authoritative `roles[]` from the server, so the session
  /// is updated from it, never from the request (D3 / role-session.md).
  Future<void> addRole(UserRole role) async {
    if (state.isAddingRole) return;
    emit(state.copyWith(isAddingRole: true, errorMessage: null));
    try {
      final User user = await _repository.addRole(role);
      _session.updateRoles(user.roles.map((UserRole r) => r.name).toSet());
      emit(state.copyWith(
        isAddingRole: false,
        isSuccess: true,
        user: user,
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(
        isAddingRole: false,
        errorMessage: failureMessage(_l10n, failure),
      ));
    } catch (_) {
      emit(state.copyWith(
        isAddingRole: false,
        errorMessage: _l10n.errorServer,
      ));
    }
  }

  /// Switches the active dashboard role, persists the last-used choice, and
  /// reflects it on the session. Server truth wins: the persisted value is
  /// written from the returned [User], never from the request (D3).
  Future<void> switchActiveRole(UserRole role) async {
    if (state.isSwitchingRole) return;
    emit(state.copyWith(isSwitchingRole: true, errorMessage: null));
    try {
      final User user = await _repository.switchActiveRole(role);
      await _preferences.setString(activeRoleKey, user.activeRole.name);
      _session.updateActiveRole(user.activeRole);
      emit(state.copyWith(
        isSwitchingRole: false,
        isSuccess: true,
        user: user,
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(
        isSwitchingRole: false,
        errorMessage: failureMessage(_l10n, failure),
      ));
    } catch (_) {
      emit(state.copyWith(
        isSwitchingRole: false,
        errorMessage: _l10n.errorServer,
      ));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/router/route_guards.dart';
import '../../repository/onboarding_repository.dart';

part 'onboarding_cubit.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int pageIndex,
    @Default(false) bool isCompleted,
    @Default(true) bool isBootstrapping,
  }) = _OnboardingState;
}

/// First-launch onboarding (3 pages). Owns the swipe/button page index and
/// the completed flag that gates every route via the router's [OnboardingReader].
///
/// Registered as `@LazySingleton`; bootstrap resolves it and awaits
/// [initialize] before `runApp` so the flag is known on the first frame (no
/// flash). [complete] persists the flag first-launch-once; the state then
/// emits `isCompleted`, the router's refresh listener re-evaluates, and the
/// global redirect moves the app to `/` (authenticated) or `/login`.
/// Guard against rebuilding while a `complete()` emit is landing: the router's
/// refresh listener re-evaluates redirects on that emission, but the page
/// itself may still be animating to the last card.
@LazySingleton(as: OnboardingReader)
class OnboardingCubit extends Cubit<OnboardingState>
    implements OnboardingReader {
  OnboardingCubit(this._repository) : super(const OnboardingState());

  /// Number of pages the carousel renders.
  static const int pageCount = 3;

  final OnboardingRepository _repository;

  @override
  bool get isCompleted => state.isCompleted;

  @override
  bool get isBootstrapping => state.isBootstrapping;

  /// Startup: resolve the persisted flag and clear `isBootstrapping` so
  /// router guards can read the real value on the first frame.
  Future<void> initialize() async {
    final bool completed = await _repository.isCompleted();
    emit(OnboardingState(isCompleted: completed, isBootstrapping: false));
  }

  /// Advance to the next page (no-op on the last page).
  void next() {
    if (state.pageIndex >= pageCount - 1) return;
    emit(state.copyWith(pageIndex: state.pageIndex + 1));
  }

  /// Go back a page (no-op on the first page).
  void back() {
    if (state.pageIndex <= 0) return;
    emit(state.copyWith(pageIndex: state.pageIndex - 1));
  }

  /// Sync the page index from a user swipe on the [PageView].
  void setPage(int index) {
    if (index < 0 || index >= pageCount || index == state.pageIndex) return;
    emit(state.copyWith(pageIndex: index));
  }

  /// Persist the completed flag and finish the flow. The persist is
  /// best-effort (mirrors `AuthSessionCubit.signOut`): failure must never trap
  /// the user on onboarding — the flag is simply re-persisted next launch.
  Future<void> complete() async {
    try {
      await _repository.markCompleted();
    } catch (_) {
      // Non-fatal; see doc comment above.
    }
    emit(state.copyWith(isCompleted: true, isBootstrapping: false));
  }
}
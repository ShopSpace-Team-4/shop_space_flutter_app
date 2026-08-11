import 'package:injectable/injectable.dart';

import '../../../core/storage/preferences_service.dart';

/// First-launch gate backed by `shared_preferences`.
///
/// Onboarding is a local-only, once-per-install flow: there is deliberately
/// no `data/` folder — no datasource/dio/models exist here. The implementation
/// goes straight through the injected [PreferencesService] (core storage),
/// following the same seam as [LocalizationCubit]'s locale. A repository
/// interface method IS the use case (constitution §Architecture).
abstract class OnboardingRepository {
  /// Whether the onboarding flag is currently set.
  Future<bool> isCompleted();

  /// Persist the flag so onboarding is never shown again.
  Future<void> markCompleted();
}

@Injectable(as: OnboardingRepository)
class PreferencesOnboardingRepository implements OnboardingRepository {
  PreferencesOnboardingRepository(this._preferences);

  static const String _completedKey = 'onboarding_completed';

  final PreferencesService _preferences;

  @override
  Future<bool> isCompleted() async {
    return await _preferences.getString(_completedKey) == 'true';
  }

  @override
  Future<void> markCompleted() =>
      _preferences.setString(_completedKey, 'true');
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shop_space/core/localization/localization_cubit.dart';
import 'package:shop_space/core/storage/preferences_service.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  const persistedLocale = 'ar';
  const key = 'locale';

  group('LocalizationCubit', () {
    late MockPreferencesService preferences;

    setUp(() {
      preferences = MockPreferencesService();
    });

    test('defaults to en when nothing is persisted', () async {
      when(() => preferences.getString(key)).thenAnswer((_) async => null);

      final cubit = LocalizationCubit(preferences);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, const Locale('en'));
    });

    test('loads persisted locale on start', () async {
      when(() => preferences.getString(key))
          .thenAnswer((_) async => persistedLocale);

      final cubit = LocalizationCubit(preferences);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, const Locale(persistedLocale));
    });

    test('setLocale updates state and persists it', () async {
      when(() => preferences.getString(key)).thenAnswer((_) async => null);
      when(() => preferences.setString(key, persistedLocale))
          .thenAnswer((_) async {});

      final cubit = LocalizationCubit(preferences);

      await cubit.setLocale(const Locale(persistedLocale));

      expect(cubit.state, const Locale(persistedLocale));
      verify(() => preferences.setString(key, persistedLocale)).called(1);
    });

    test('setLocale emits the new locale on the stream', () async {
      when(() => preferences.getString(key)).thenAnswer((_) async => null);
      when(() => preferences.setString(key, persistedLocale))
          .thenAnswer((_) async {});

      final cubit = LocalizationCubit(preferences);
      final emitted = <Locale>[];
      final sub = cubit.stream.listen(emitted.add);

      await cubit.setLocale(const Locale(persistedLocale));
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(emitted, contains(const Locale(persistedLocale)));
    });
  });
}

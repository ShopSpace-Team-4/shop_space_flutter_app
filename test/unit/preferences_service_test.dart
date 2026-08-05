import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_space/core/storage/preferences_service.dart';

class MockSharedPreferencesAsync extends Mock
    implements SharedPreferencesAsync {}

void main() {
  late MockSharedPreferencesAsync prefs;
  late SharedPreferencesService service;

  setUp(() {
    prefs = MockSharedPreferencesAsync();
    service = SharedPreferencesService(prefs: prefs);
  });

  test('getString reads the requested key through the backing store',
      () async {
    when(() => prefs.getString('locale')).thenAnswer((_) async => 'ar');

    expect(await service.getString('locale'), 'ar');
    verify(() => prefs.getString('locale')).called(1);
  });

  test('setString writes the value under the requested key', () async {
    when(() => prefs.setString('activeRole', 'tenant'))
        .thenAnswer((_) async => true);

    await service.setString('activeRole', 'tenant');

    verify(() => prefs.setString('activeRole', 'tenant')).called(1);
  });

  test('removeString removes the requested key', () async {
    when(() => prefs.remove('activeRole')).thenAnswer((_) async => true);

    await service.removeString('activeRole');

    verify(() => prefs.remove('activeRole')).called(1);
  });

  test('reserved keys locale and activeRole are used', () async {
    when(() => prefs.getString(any())).thenAnswer((_) async => null);
    when(() => prefs.setString(any(), any())).thenAnswer((_) async => true);

    await service.setString('locale', 'en');
    await service.setString('activeRole', 'tenant');
    await service.getString('locale');

    verify(() => prefs.setString('locale', 'en')).called(1);
    verify(() => prefs.setString('activeRole', 'tenant')).called(1);
    verify(() => prefs.getString('locale')).called(1);
  });
}

import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferencesService {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<void> removeString(String key);
}

class SharedPreferencesService implements PreferencesService {
  SharedPreferencesService({SharedPreferencesAsync? prefs})
      : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;

  @override
  Future<String?> getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  Future<void> removeString(String key) => _prefs.remove(key);
}

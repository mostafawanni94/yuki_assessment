import 'package:shared_preferences/shared_preferences.dart';
import 'i_local_storage.dart';

/// SharedPreferences implementation of [ILocalStorage].
///
/// To swap to Hive: create HiveStorage implements ILocalStorage.
/// To swap to SecureStorage: create SecureLocalStorage implements ILocalStorage.
/// Zero other changes needed.
class SharedPreferencesStorage implements ILocalStorage {
  SharedPreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> getString(String key) async => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async =>
      _prefs.setString(key, value);

  @override
  Future<bool?> getBool(String key) async => _prefs.getBool(key);

  @override
  Future<void> setBool(String key, bool value) async =>
      _prefs.setBool(key, value);

  @override
  Future<int?> getInt(String key) async => _prefs.getInt(key);

  @override
  Future<void> setInt(String key, int value) async =>
      _prefs.setInt(key, value);

  @override
  Future<void> remove(String key) async => _prefs.remove(key);

  @override
  Future<void> clear() async => _prefs.clear();
}

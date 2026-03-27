/// Contract for key-value local persistence.
///
/// Single Responsibility: storage operations only — no business logic.
/// Abstraction allows swapping SharedPreferences → Hive → SecureStorage
/// without touching any feature code.
///
/// All methods are async — every storage backend needs this.
abstract interface class ILocalStorage {
  /// Reads a [String] value. Returns null if key not found.
  Future<String?> getString(String key);

  /// Writes a [String] value.
  Future<void> setString(String key, String value);

  /// Reads a [bool] value. Returns null if key not found.
  Future<bool?> getBool(String key);

  /// Writes a [bool] value.
  Future<void> setBool(String key, bool value);

  /// Reads an [int] value. Returns null if key not found.
  Future<int?> getInt(String key);

  /// Writes an [int] value.
  Future<void> setInt(String key, int value);

  /// Removes a key.
  Future<void> remove(String key);

  /// Clears ALL stored values.
  Future<void> clear();
}

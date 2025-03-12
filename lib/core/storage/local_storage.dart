import 'package:hive/hive.dart';

class LocalStorage {
  static late Box _box;

  /// Initialize Hive box
  static Future<void> init(String boxName) async {
    _box = await Hive.openBox(boxName);
  }

  /// Get value
  static T? get<T>(String key) => _box.get(key);

  /// Get value asynchronously
  static Future<T?> getAsync<T>(String key) async => await _box.get(key);

  /// Set value
  static Future<void> set<T>(String key, T value) async => await _box.put(key, value);

  /// Remove value
  static Future<void> remove(String key) async => await _box.delete(key);

  /// Clear all values
  static Future<void> clear() async => await _box.clear();

  /// Get all values
  static Map<dynamic, dynamic> getAll() => _box.toMap();
}

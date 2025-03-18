import 'package:hive/hive.dart';

class LocalStorage {
  LocalStorage._();

  static late Box _box;

  static Future<void> init(String boxName) async {
    _box = await Hive.openBox(boxName);
  }

  static T? get<T>(String key) => _box.get(key);

  static Future<void> set<T>(String key, T value) async => await _box.put(key, value);

  static Future<void> remove(String key) async => await _box.delete(key);

  static Future<void> clear() async => await _box.clear();

  static bool containsKey(String key) => _box.containsKey(key);

  static Map<dynamic, dynamic> getAll() => _box.toMap();

  static Set<dynamic> getAllKeys() => _box.keys.toSet();

  static int count() => _box.length;

  /// Watch for changes to a specific key
  static Stream<BoxEvent> watch({String? key}) => _box.watch(key: key);

  /// Batch operations for performance optimization
  static Future<void> batch(Function(Box box) operations) async {
    await _box.flush(); // Ensure previous operations are written
    operations(_box);
    await _box.flush(); // Commit batch operations
  }

  // Compile-time type safety for specific types
  static Future<String?> getString(String key) async => get<String>(key);

  static Future<bool?> getBool(String key) async => get<bool>(key);

  static Future<int?> getInt(String key) async => get<int>(key);

  static Future<double?> getDouble(String key) async => get<double>(key);

  static Future<Map<String, dynamic>?> getMap(String key) async => get<Map<String, dynamic>>(key);

  static Future<List<dynamic>?> getList(String key) async => get<List<dynamic>>(key);
}

import 'dart:convert';

import 'package:vintiora/core/storage/local_storage.dart';

/// Abstract cache service interface.
abstract class CacheService {
  Future<dynamic> get(String key);

  Future<void> set(String key, dynamic data, {Duration? expiry});

  Future<void> remove(String key);

  Future<void> removeAll();

  Future<bool> isExpired(String key);
}

/// Implementation of [CacheService] that uses [LocalStorage] for caching.
class CacheServiceImpl implements CacheService {
  /// A prefix to isolate cache keys from other keys in the app.
  static const String _cachePrefix = 'cache_';

  /// Formats the data key with the cache prefix.
  String _formatKey(String key) => '$_cachePrefix$key';

  /// Formats the expiry key with the cache prefix.
  String _formatExpiryKey(String key) => '$_cachePrefix${key}_expiry';

  @override
  Future<dynamic> get(String key) async {
    // Retrieve the JSON string from local storage using the prefixed key.
    final jsonString = LocalStorage.get<String>(_formatKey(key));
    if (jsonString == null) return null;

    // Check if there is an expiry timestamp associated with this key.
    final expiryTimestamp = await LocalStorage.get(_formatExpiryKey(key));
    if (expiryTimestamp != null && DateTime.now().millisecondsSinceEpoch > expiryTimestamp) {
      // If the cached data has expired, remove it.
      await remove(key);
      return null;
    }

    // Deserialize the JSON data.
    return jsonDecode(jsonString);
  }

  @override
  Future<void> set(String key, dynamic data, {Duration? expiry}) async {
    final fullKey = _formatKey(key);
    // Serialize data to JSON before storing.
    await LocalStorage.set<String>(fullKey, jsonEncode(data));

    // If an expiry is provided, calculate and store the expiry timestamp.
    if (expiry != null) {
      final expiryTimestamp = DateTime.now().add(expiry).millisecondsSinceEpoch;
      await LocalStorage.set(_formatExpiryKey(key), expiryTimestamp);
    }
  }

  @override
  Future<void> remove(String key) async {
    // Remove both the cached data and its associated expiry.
    await LocalStorage.remove(_formatKey(key));
    await LocalStorage.remove(_formatExpiryKey(key));
  }

  @override
  Future<void> removeAll() async {
    // This implementation will clear only the keys used by the CacheService.
    final keys = LocalStorage.getAll().keys;

    // Filter keys that are prefixed with the cache namespace.
    final cacheKeys = keys.where((key) => key.startsWith(_cachePrefix)).toList();

    // Remove each cache key.
    for (final key in cacheKeys) {
      await LocalStorage.remove(key);
    }
  }

  @override
  Future<bool> isExpired(String key) async {
    final expiryTimestamp = await LocalStorage.get(_formatExpiryKey(key));
    if (expiryTimestamp == null) return false;
    return DateTime.now().millisecondsSinceEpoch > expiryTimestamp;
  }
}

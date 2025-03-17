import 'dart:convert';

import 'package:vintiora/core/storage/local_storage.dart';

/// Abstract cache service interface.
abstract class CacheService {
  Future<dynamic> get(String key);

  Future<void> set(String key, dynamic value, {Duration expiry = const Duration(minutes: 5)});

  Future<void> remove(String key);

  Future<void> removeAll();
}

/// Implementation of [CacheService] that uses [LocalStorage] for caching.
class CacheServiceImpl implements CacheService {
  /// A prefix to isolate cache keys from other keys in the app.
  static const String _cachePrefix = 'app_cache';

  /// Formats the data key with the cache prefix.
  String _getCacheKey(String key) => '$_cachePrefix:$key';

  @override
  Future<dynamic> get(String key) async {
    // Retrieve the JSON string from local storage using the prefixed key.
    final cachedData = LocalStorage.get<String>(_getCacheKey(key));

    if (cachedData != null) {
      final decodedData = jsonDecode(cachedData);
      final expiryTime = decodedData['expiry'] as int;

      if (DateTime.now().millisecondsSinceEpoch < expiryTime) {
        return decodedData['data'];
      } else {
        await remove(key);
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> set(String key, dynamic value, {Duration expiry = const Duration(minutes: 5)}) async {
    final fullKey = _getCacheKey(key);

    final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
    final cacheData = {
      'data': value,
      'expiry': expiryTime,
    };
    await LocalStorage.set<String>(fullKey, jsonEncode(cacheData));
  }

  @override
  Future<void> remove(String key) async {
    await LocalStorage.remove(_getCacheKey(key));
  }

  @override
  Future<void> removeAll() async {
    final keys = LocalStorage.getAll().keys;

    // Filter keys that are prefixed with the cache namespace.
    final cacheKeys = keys.where((key) => key.startsWith(_cachePrefix)).toList();

    for (final key in cacheKeys) {
      await LocalStorage.remove(key);
    }
  }
}

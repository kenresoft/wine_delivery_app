import 'dart:convert';

import 'package:vintiora/core/storage/local_storage.dart';

abstract class CacheService {
  Future<dynamic> get(String key);

  Future<void> set(String key, dynamic value, {Duration expiry = const Duration(minutes: 5)});

  Future<void> remove(String key);

  Future<void> removeAll();
}

class CacheServiceImpl implements CacheService {
  static const String _cachePrefix = 'APP_CACHE';

  String _getCacheKey(String key) => '$_cachePrefix:$key';

  @override
  Future<dynamic> get(String key) async {
    // remove("/flash-sales/active");
    final cachedData = LocalStorage.get<String>(_getCacheKey(key));

    if (cachedData != null) {
      final decodedData = jsonDecode(cachedData);
      final expiryTime = decodedData['expiry'] as int; // CachePolicy.getExpiry(key).inMilliseconds

      if (DateTime.now().millisecondsSinceEpoch < expiryTime ) {
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

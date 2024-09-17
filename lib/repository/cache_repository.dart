import 'dart:convert';

import 'package:extensionresoft/extensionresoft.dart';

class CacheRepository {
  CacheRepository._();

  static final CacheRepository _instance = CacheRepository._();

  static CacheRepository getInstance() => _instance;

  static const int defaultExpirationInSeconds = 3600; // Default cache duration (1 hour)

  /// Caches data with a specified key. Data will expire after [expirationInSeconds].
  /// If no data is passed (null), it skips caching.
  Future<void> cache(
    String key,
    String? body, {
    int expirationInSeconds = defaultExpirationInSeconds, // Added parameter flexibility
  }) async {
    if (body != null && body.isNotEmpty) {
      final now = DateTime.now();
      final expirationTime = now.add(Duration(seconds: expirationInSeconds));
      final cachedData = {
        'data': body,
        'expiration': expirationTime.millisecondsSinceEpoch,
      };

      await SharedPreferencesService.setString(key, jsonEncode(cachedData));
    } else {
      // Handle case where no data is cached for the key
    }
  }

  /// Retrieves cached data by key if it exists and hasn't expired.
  /// Returns null if data has expired or doesn't exist.
  String? getCache(String key) {
    final cachedDataString = SharedPreferencesService.getString(key);
    if (cachedDataString?.isNotEmpty == true) {
      final cachedData = jsonDecode(cachedDataString!) as Map<String, dynamic>;
      final expirationTime = DateTime.fromMillisecondsSinceEpoch(cachedData['expiration']);

      if (DateTime.now().isBefore(expirationTime)) {
        return cachedData['data'] as String;
      } else {
        // Data has expired, so clear the cache for this key.
        clearCache(key);
      }
    }
    return null;
  }

  /// Checks if valid (non-expired) cache exists for a specific key.
  bool hasCache(String key) {
    final cacheData = getCache(key);
    return cacheData != null && cacheData.isNotEmpty;
  }

  /// Clears the cache for the provided key.
  Future<void> clearCache(String key) async {
    await SharedPreferencesService.remove(key);
  }

  /// Clears all cached data (optional function for broader cache management).
  Future<void> clearAllCache() async {
    await SharedPreferencesService.clear(); // Be cautious; this clears all data, not just cache.
  }
}

final CacheRepository cacheRepository = CacheRepository.getInstance();

import 'dart:convert';

import 'package:extensionresoft/extensionresoft.dart';

import '../model/cache_entry.dart';

class CacheRepository {
  CacheRepository._();

  static final CacheRepository _instance = CacheRepository._();

  static CacheRepository getInstance() => _instance;

  /// Caches data with a specified key and expiration.
  Future<void> cache<T>(
    String key,
    CacheEntry<T> entry,
  ) async {
    final cachedData = jsonEncode(entry.toJson());
    await SharedPreferencesService.setString(key, cachedData);
  }

  /// Retrieves a cached entry by key if it exists and hasn't expired.
  /// Returns null if the data has expired or doesn't exist.
  CacheEntry<T>? getCache<T>(String key, T Function(dynamic) dataParser) {
    final cachedDataString = SharedPreferencesService.getString(key);
    if (cachedDataString?.isNotEmpty == true) {
      final cachedData = jsonDecode(cachedDataString!) as Map<String, dynamic>;
      final cacheEntry = CacheEntry.fromJson(cachedData, dataParser);

      if (!cacheEntry.isExpired()) {
        return cacheEntry;
      } else {
        // Data has expired, clear the cache for this key.
        clearCache(key);
      }
    }
    return null;
  }

  /// Checks if valid (non-expired) cache exists for a specific key.
  bool hasCache<T>(String key, T Function(dynamic) dataParser) {
    final cacheEntry = getCache(key, dataParser);
    return cacheEntry != null && !cacheEntry.isExpired();
  }

  /// Clears the cache for the provided key.
  Future<void> clearCache(String key) async {
    await SharedPreferencesService.remove(key);
  }

  /// Clears all cached data (optional function for broader cache management).
  Future<void> clearAllCache() async {
    //TODO:
    await SharedPreferencesService.clear(); // Be cautious; this clears all data, not just cache.
  }

  // Caching a response
  Future<void> storeApiResponse(String cacheKey, dynamic apiResponse) async {
    final cacheEntry = CacheEntry.withDefaultExpiration(apiResponse);
    await cacheRepository.cache(cacheKey, cacheEntry);
  }

  // Retrieving cached data
  dynamic getApiResponseFromCache(String cacheKey) {
    final cacheEntry = cacheRepository.getCache(cacheKey, (data) {
      return jsonDecode(data);
    });
    if (cacheEntry != null) {
      return cacheEntry.data; // Return cached data if valid
    } else {
      // Handle case where cache is expired or doesn't exist
      return null;
    }
  }
}

final CacheRepository cacheRepository = CacheRepository.getInstance();

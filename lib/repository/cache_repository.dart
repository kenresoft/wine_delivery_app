import 'dart:convert';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:wine_delivery_app/utils/extensions.dart';

import '../utils/utils.dart';

class CacheRepository {
  CacheRepository._();

  static final CacheRepository _instance = CacheRepository._();

  static CacheRepository getInstance() => _instance;

  static const expirationInSeconds = 3600; // Cache for 1 hour

  Future<void> cache(
    String key,
    String? body,
    /*{int expirationInSeconds = 3600}*/
  ) async {
    if (body != null) {
      final now = DateTime.now();
      final expirationTime = now.add(const Duration(seconds: expirationInSeconds));
      final cachedData = {
        'data': body,
        'expiration': expirationTime.millisecondsSinceEpoch,
      };
      await SharedPreferencesService.setString(key, jsonEncode(cachedData));
    } else {
      // Handle case where no data is cached for the key
    }
  }

  String? getCache(String key) {
    final cachedDataString = SharedPreferencesService.getString(key);
    if (cachedDataString?.isNullOrEmpty != true) {
      final cachedData = jsonDecode(cachedDataString!);
      final expirationTime = DateTime.fromMillisecondsSinceEpoch(cachedData['expiration']);
      if (DateTime.now().isBefore(expirationTime)) {
        return cachedData['data'];
      }
    }
    return null; // Or handle the case where the cached data is empty or invalid
  }

/*  Future<void> cache(String key, String? body) async {
    if (body != null) {
      await SharedPreferencesService.setString(key, body);
    } else {
      // Handle case where no data is cached for the key
    }
  }

  String? getCache(String key) {
    final cachedData = SharedPreferencesService.getString(key);
    if (cachedData?.isNullOrEmpty != true) {
      return cachedData;
    }
    return null; // Or handle the case where the cached data is empty or invalid
  }*/

  bool hasCache(String key) {
    return SharedPreferencesService.containsKey(key) && !(getCache(key))!.isNullOrEmpty;
  }

  Future<void> clearCache(String key) async {
    await SharedPreferencesService.remove(key);
  }
}

final CacheRepository cacheRepository = CacheRepository.getInstance();

Future<T> decide<T>({
  required String cacheKey,
  required String endpoint,
  required Future<T> Function(dynamic data) function,
}) async {
  if (!cacheRepository.hasCache(cacheKey)) {
    final response = await Utils.makeRequest(endpoint);

    if (response.statusCode == 200) {
      await cacheRepository.cache(cacheKey, response.body);
    } else {
      await cacheRepository.cache(cacheKey, null); // Or handle error
      Utils.handleError(response);
    }
  }

  final cachedData = cacheRepository.getCache(cacheKey);
  if (cachedData != null) {
    print('Data fetched from cache');
    return function(jsonDecode(cachedData));
    // return _fetchOrders(cachedData);
  }

  // No cache or invalid cache, fetch from API
  final response = await Utils.makeRequest(endpoint);
  if (response.statusCode == 200) {
    await cacheRepository.cache(cacheKey, response.body);
    print('Data fetched from API');
    return function(jsonDecode(response.body));
    // return _fetchOrders(response.body);
  } else {
    throw Utils.handleError(response);
  }
}
import 'dart:convert';
import 'dart:io';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:wine_delivery_app/model/order.dart';
import 'package:wine_delivery_app/repository/cache_repository.dart';
import 'package:wine_delivery_app/utils/enums.dart';
import 'package:wine_delivery_app/utils/extensions.dart';

import '../model/cache_entry.dart';
import '../utils/preferences.dart';
import '../utils/utils.dart';

class DecisionRepository {
  final CacheRepository _cacheRepository;

  DecisionRepository._(this._cacheRepository);

  factory DecisionRepository() {
    return DecisionRepository._(cacheRepository);
  }

  /// Fetches data from both cache and API, compares them, and refreshes the cache if needed.
  /// Bypasses cache when an active internet connection is available for faster responses.
  Future<T> decide<T>({
    required String cacheKey,
    required String endpoint,
    RequestMethod requestMethod = RequestMethod.get,
    dynamic body,
    required Future<T> Function(dynamic data) onSuccess,
    required Future<T> Function(dynamic error) onError,
  }) async {
    final stopwatch = Stopwatch()..start();
    logger.i("Decision process started for cacheKey: $cacheKey");

    final CacheEntry<String>? cachedEntry = _cacheRepository.getCache(cacheKey, (data) => data as String);

    try {
      final result = await _fetchData(cacheKey, endpoint, requestMethod, body, cachedEntry);
      final freshApiData = result.freshApiData;

      if (freshApiData != null) {
        final decodedApiData = jsonDecode(freshApiData);
        await _updateCacheIfNeeded(cacheKey, cachedEntry, freshApiData, decodedApiData);
        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return onSuccess(decodedApiData);
      } else if (cachedEntry != null) {
        final decodedCacheData = jsonDecode(cachedEntry.data);
        logger.i('API failed, using cached data.');
        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return onSuccess(decodedCacheData);
      } else {
        logger.e("No data available from cache or API.");
        return onError('No data available from cache or API.');
      }
    } on SocketException {
      return _handleSocketException(onSuccess, onError, cachedEntry, stopwatch);
    } catch (e) {
      return _handleException(onError, e, stopwatch);
    } finally {
      stopwatch.stop();
    }
  }

  /// Fetches data either from API when online or from cache when offline.
  Future<({CacheEntry<String>? cachedEntry, String? freshApiData})> _fetchData(
    String cacheKey,
    String endpoint,
    RequestMethod requestMethod,
    dynamic body,
    CacheEntry<String>? cachedEntry,
  ) async {

    if (isInternet) {
      logger.d('Internet connection available. Fetching fresh data from API.');
      final apiResponse = await Utils.makeRequest(endpoint, method: requestMethod, body: body);
      if (apiResponse.statusCode == 200) {
        return (cachedEntry: null, freshApiData: apiResponse.body);
      } else {
        logger.e('API request failed with status: ${apiResponse.statusCode}');
      }
    }

    return (cachedEntry: cachedEntry, freshApiData: null);
  }

  /// Updates cache if API data differs from the cached data.
  Future<void> _updateCacheIfNeeded(
    String cacheKey,
    CacheEntry<String>? cachedEntry,
    String freshApiData,
    dynamic decodedApiData,
  ) async {
    if (cachedEntry != null) {
      final decodedCacheData = jsonDecode(cachedEntry.data);
      if (_hasDataChanged(decodedCacheData, decodedApiData)) {
        logger.w('Data changed. Updating cache.');
        await _cacheRepository.cache(cacheKey, CacheEntry.withDefaultExpiration(freshApiData));
      }
    } else {
      logger.w('No cache available. Storing new API data in cache.');
      await _cacheRepository.cache(cacheKey, CacheEntry.withDefaultExpiration(freshApiData));
    }
  }

  /// Handles the case where there is a socket exception (e.g., no internet).
  Future<T> _handleSocketException<T>(
    Future<T> Function(dynamic data) onSuccess,
    Future<T> Function(dynamic error) onError,
    CacheEntry<String>? cachedEntry,
    Stopwatch stopwatch,
  ) async {
    if (cachedEntry != null) {
      final decodedCacheData = jsonDecode(cachedEntry.data);
      logger.e('Socket Exception - No internet, using cached data.');
      return onSuccess(decodedCacheData);
    }
    logger.i("No internet or cache data. Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
    return onError('SocketException: No API or cache data available.');
  }

  /// Handles general exceptions and ensures logging consistency.
  Future<T> _handleException<T>(
    Future<T> Function(dynamic error) onError,
    dynamic error,
    Stopwatch stopwatch,
  ) async {
    logger.e('Exception occurred: $error');
    logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
    return onError(error);
  }

  /// Compares cached data with API data to check if they differ.
  bool _hasDataChanged(dynamic cachedData, dynamic apiData) {
    return jsonEncode(cachedData) != jsonEncode(apiData);
  }
}

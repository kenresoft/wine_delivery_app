import 'dart:convert';
import 'dart:io';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:wine_delivery_app/repository/cache_repository.dart';
import 'package:wine_delivery_app/utils/enums.dart';

import '../model/cache_entry.dart';
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
    // Initialize stopwatch
    final stopwatch = Stopwatch()..start();
    logger.i("Decision process started for cacheKey: $cacheKey");

    final CacheEntry<String>? cachedEntry = _cacheRepository.getCache(cacheKey, (data) => data as String);

    /*try {
      final result = await confirmInternetOnData(
        cacheKey: cacheKey,
        endpoint: endpoint,
        requestMethod: requestMethod,
        body: body,
        cachedEntry: cachedEntry,
      );

      final freshApiData = result.freshApiData;

      if (freshApiData != null) {
        // Use fresh API data and update cache if necessary
        final decodedApiData = jsonDecode(freshApiData);
        if (cachedEntry != null) {
          final decodedCacheData = jsonDecode(cachedEntry.data);
          if (_hasDataChanged(decodedCacheData, decodedApiData)) {
            logger.w('Data changed. Updating cache.');
            final newCacheEntry = CacheEntry.withDefaultExpiration(freshApiData);
            await _cacheRepository.cache(cacheKey, newCacheEntry);
          }
        } else {
          logger.w('No cache available. Storing new API data in cache.');
          final newCacheEntry = CacheEntry.withDefaultExpiration(freshApiData);
          await _cacheRepository.cache(cacheKey, newCacheEntry);
        }

        // Log the elapsed time
        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return onSuccess(decodedApiData);
      } else if (cachedEntry != null) {
        // Fallback to cache if API fails or no data is fetched
        final decodedCacheData = jsonDecode(cachedEntry.data);
        logger.i('API failed, using cached data.');
        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return onSuccess(decodedCacheData);
      } else {
        logger.e("No data available from cache or API.");
        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return onError('No data available from cache or API.');
      }
    } on SocketException {
      if (cachedEntry != null) {
        logger.e('Socket Exception - No internet, using cached data.');
        final decodedCacheData = jsonDecode(cachedEntry.data);
        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return onSuccess(decodedCacheData);
      }
      logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
      return onError('SocketException: No API or cache data available.');
    } on Exception catch (e) {
      logger.e('Exception occurred: $e');
      logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
      return onError(e);
    } finally {
      stopwatch.stop();
    }*/

    try {
      final result = await confirmInternetOnData(
        cacheKey: cacheKey,
        endpoint: endpoint,
        requestMethod: requestMethod,
        body: body,
        cachedEntry: cachedEntry,
      );

      final freshApiData = result.freshApiData;

      if (freshApiData != null) {
        // Decode the fresh API data
        final decodedApiData = jsonDecode(freshApiData);

        // Return the data immediately to the UI
        onSuccess(decodedApiData);

        // Perform cache updating and data change detection in the background
        _processDataInBackground(cachedEntry, freshApiData, cacheKey);

        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return onSuccess(decodedApiData);
      } else if (cachedEntry != null) {
        // Fallback to cache if API fails or no data is fetched
        final decodedCacheData = jsonDecode(cachedEntry.data);
        logger.i('API failed, using cached data.');

        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return onSuccess(decodedCacheData);
      } else {
        logger.e("No data available from cache or API.");
        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return onError('No data available from cache or API.');
      }
    } on SocketException {
      if (cachedEntry != null) {
        logger.e('Socket Exception - No internet, using cached data.');
        final decodedCacheData = jsonDecode(cachedEntry.data);
        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return onSuccess(decodedCacheData);
      }
      logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
      return onError('SocketException: No API or cache data available.');
    } on Exception catch (e) {
      logger.e('Exception occurred: $e');
      logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
      return onError(e);
    } finally {
      stopwatch.stop();
    }
  }

  /// Confirms internet availability and retrieves data either from API (when online) or cache (when offline).
  Future<({CacheEntry<String>? cachedEntry, String? freshApiData})> confirmInternetOnData({
    required String cacheKey,
    required String endpoint,
    RequestMethod requestMethod = RequestMethod.get,
    dynamic body,
    CacheEntry<String>? cachedEntry,
  }) async {
    // Initialize stopwatch
    final stopwatch = Stopwatch()..start();
    logger.i("Checking internet connection and fetching data for $cacheKey");

    try {
      final hasInternetAccess = await InternetConnectionChecker().hasInternetAccess();
      logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
      
      if (hasInternetAccess) {
        logger.i('Internet connection available. Fetching fresh data from API.');
      
        // Always attempt to fetch fresh data from the API when online
        final apiResponse = await Utils.makeRequest(endpoint, method: requestMethod, body: body);
        logger.i("API request completed in ${stopwatch.elapsedMilliseconds} ms");
      
        if (apiResponse.statusCode == 200) {
          logger.i('API request successful for $cacheKey');
          logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
          return (cachedEntry: null, freshApiData: apiResponse.body);
        } else {
          logger.e('API request failed with status: ${apiResponse.statusCode}');
          // Fallback to cache if available when API fails
          logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
          return (cachedEntry: cachedEntry, freshApiData: null);
        }
      } else if (cachedEntry != null) {
        logger.i('No internet access, using cached data for $cacheKey');
        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return (cachedEntry: cachedEntry, freshApiData: null);
      } else {
        logger.e('No internet access and no cached data available');
        logger.i("Decision process completed in ${stopwatch.elapsedMilliseconds} ms");
        return (cachedEntry: null, freshApiData: null);
      }
    } finally {
      stopwatch.stop();
    }
  }

  /// Helper function to determine if the data has changed.
  bool _hasDataChanged(dynamic cachedData, dynamic apiData) {
    return jsonEncode(cachedData) != jsonEncode(apiData);
  }

  /// Detects conflicts between cached data and API data using version fields.
  bool _hasConflict(dynamic cachedData, dynamic apiData) {
    return _findVersion(cachedData) != _findVersion(apiData);
  }

  /// Extracts the version field from data to be used for conflict detection.
  int? _findVersion(Map<String, dynamic> data) {
    if (data.containsKey('__v')) {
      return data['__v'] as int?;
    }

    for (var value in data.values) {
      if (value is Map<String, dynamic>) {
        final foundVersion = _findVersion(value);
        if (foundVersion != null) {
          return foundVersion;
        }
      }
    }

    return null;
  }

  /// This method processes data in the background after returning the API response.
  void _processDataInBackground(CacheEntry<String>? cachedEntry, String freshApiData, String cacheKey) async {
    final decodedApiData = jsonDecode(freshApiData);

    if (cachedEntry != null) {
      final decodedCacheData = jsonDecode(cachedEntry.data);
      if (_hasDataChanged(decodedCacheData, decodedApiData)) {
        logger.w('Data changed. Updating cache.');
        final newCacheEntry = CacheEntry.withDefaultExpiration(freshApiData);
        await _cacheRepository.cache(cacheKey, newCacheEntry);
      }
    } else {
      logger.w('No cache available. Storing new API data in cache.');
      final newCacheEntry = CacheEntry.withDefaultExpiration(freshApiData);
      await _cacheRepository.cache(cacheKey, newCacheEntry);
    }
  }

}

// final DecisionRepository decisionRepository = DecisionRepository._(cacheRepository);
import 'dart:convert';
import 'dart:io';

import 'package:wine_delivery_app/repository/cache_repository.dart';
import 'package:wine_delivery_app/utils/enums.dart';
import 'package:wine_delivery_app/utils/extensions.dart';

import '../utils/utils.dart';

class DecisionRepository {
  final CacheRepository _cacheRepository;

  DecisionRepository._(this._cacheRepository);

  /// Fetches data from both cache and API, compares them, and refreshes the cache if needed.
  /// Processes the result via [onSuccess] or handles errors via [onError].
  Future<T> decide<T>({
    required String cacheKey,
    required String endpoint,
    RequestMethod requestMethod = RequestMethod.get,
    dynamic body,
    required Future<T> Function(dynamic data) onSuccess,
    required Future<T> Function(dynamic error) onError,
  }) async {
    // Retrieve cached data (if any)
    final cachedData = _cacheRepository.getCache(cacheKey);
    try {

      // Fetch data from the API
      final apiResponse = await Utils.makeRequest(endpoint, method: requestMethod, body: body);
      if (apiResponse.statusCode != 200) {
        logger.e('API request failed with status: ${apiResponse.statusCode}');
        return onError(Utils.handleError(apiResponse));
      }

      final freshApiData = apiResponse.body;

      if (cachedData != null) {
        // Compare API data with cached data
        final decodedCacheData = jsonDecode(cachedData);
        final decodedApiData = jsonDecode(freshApiData);

        // Check for conflicts
        /*if (_hasConflict(decodedCacheData, decodedApiData)) {
          print('Data conflict detected between API and cached data.');
          // Handle conflict: Notify user, log it, or decide to override.
          await _cacheRepository.cache(cacheKey, freshApiData); // Optional: overwrite cache
          return onSuccess(decodedApiData); // Proceed with API data despite conflict
        }*/

        if (_hasDataChanged(decodedCacheData, decodedApiData)) {
          logger.w('Data changed. Updating cache.');
          await _cacheRepository.cache(cacheKey, freshApiData);
        } else {
          logger.w('Data has not changed. Using cached data.');
        }

        // Use cached or API data (whichever is more appropriate based on change)
        return onSuccess(decodedApiData);
      } else {
        // Cache miss, so cache the fresh API data
        logger.w('No cache available. Storing new API data in cache.');
        await _cacheRepository.cache(cacheKey, freshApiData);
        return onSuccess(jsonDecode(freshApiData));
      }
    } on SocketException {
      if (!cachedData!.isNullOrEmpty) {
        logger.e('Socket Exception');
        final decodedCacheData = jsonDecode(cachedData);
        return onSuccess(decodedCacheData);
      }
      return onError('SocketException with No API or Cache data available');
    } on Exception catch (e) {
      logger.e('Exception occurred: $e');
      return onError(e);
    }
  }

  /// Helper function to determine if the data has changed.
  bool _hasDataChanged(dynamic cachedData, dynamic freshData) {
    // Customize this comparison based on the structure of your data.
    return jsonEncode(cachedData) != jsonEncode(freshData);
  }

  /// Detects conflicts between cached data and API data using version fields.
  bool _hasConflict(dynamic cachedData, dynamic freshData) {
    return _findVersion(cachedData) != _findVersion(freshData);
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
}

final DecisionRepository decisionRepository = DecisionRepository._(cacheRepository);

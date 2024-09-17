import 'dart:convert';

import 'package:wine_delivery_app/repository/cache_repository.dart';
import 'package:wine_delivery_app/utils/enums.dart';

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
    try {
      // Retrieve cached data (if any)
      final cachedData = _cacheRepository.getCache(cacheKey);

      // Fetch data from the API
      final apiResponse = await Utils.makeRequest(endpoint, method: requestMethod, body: body);
      if (apiResponse.statusCode != 200) {
        print('API request failed with status: ${apiResponse.statusCode}');
        return onError(Utils.handleError(apiResponse));
      }

      final freshApiData = apiResponse.body;

      if (cachedData != null) {
        // Compare API data with cached data
        final decodedCacheData = jsonDecode(cachedData);
        final decodedApiData = jsonDecode(freshApiData);

        if (_hasDataChanged(decodedCacheData, decodedApiData)) {
          print('Data changed. Updating cache.');
          await _cacheRepository.cache(cacheKey, freshApiData);
        } else {
          print('Data has not changed. Using cached data.');
        }

        // Use cached or API data (whichever is more appropriate based on change)
        return onSuccess(decodedApiData);
      } else {
        // Cache miss, so cache the fresh API data
        print('No cache available. Storing new API data in cache.');
        await _cacheRepository.cache(cacheKey, freshApiData);
        return onSuccess(jsonDecode(freshApiData));
      }
    } on Exception catch (e) {
      print('Exception occurred: $e');
      return onError(e);
    }
  }

  /// Helper function to determine if the data has changed.
  bool _hasDataChanged(dynamic cachedData, dynamic freshData) {
    // Customize this comparison based on the structure of your data.
    return jsonEncode(cachedData) != jsonEncode(freshData);
  }
}

final DecisionRepository decisionRepository = DecisionRepository._(cacheRepository);

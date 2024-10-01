/*
import 'dart:convert';

import 'package:wine_delivery_app/repository/cache_repository.dart';
import 'package:wine_delivery_app/utils/enums.dart';

import '../../utils/utils.dart';

class DecisionRepositoryBackup {
  final CacheRepository _cacheRepository;

  DecisionRepositoryBackup._(this._cacheRepository);

  /// Decides whether to fetch data from the cache or the API, processes the result
  /// via [onSuccess] or handles errors via [onError].
  Future<T> decide<T>({
    required String cacheKey,
    required String endpoint,
    RequestMethod requestMethod = RequestMethod.get,
    dynamic body,
    required Future<T> Function(dynamic data) onSuccess,
    required Future<T> Function(dynamic error) onError,
  }) async {
    try {
      // Check if valid cache exists
      if (!_cacheRepository.hasCache(cacheKey)) {
        // No cache, fetch from API
        final response = await Utils.makeRequest(endpoint, method: requestMethod, body: body);

        if (response.statusCode == 200) {
          logger.i('Data fetched from API and cached.');
          await _cacheRepository.cache(cacheKey, response.body);
        } else {
          logger.e('API request failed with status: ${response.statusCode}');
          await _cacheRepository.cache(cacheKey, null); // Optional: cache empty or null result
          return onError(Utils.handleError(response));
        }
      }

      // Retrieve cached data
      final cachedData = _cacheRepository.getCache(cacheKey);
      if (cachedData != null) {
        try {
          final decodedData = jsonDecode(cachedData);
          return onSuccess(decodedData);
        } catch (e) {
          // Handle decoding error
          logger.e('Error decoding cached data: $e');
          return onError(e);
          // return await _fetchData(endpoint); // Or handle error gracefully
        }
      } else {
        // Fallback: No valid cache, refetch from API
        final response = await Utils.makeRequest(endpoint, method: requestMethod, body: body);

        if (response.statusCode == 200) {
          logger.i('Data refetched from API and cached.');
          await _cacheRepository.cache(cacheKey, response.body);
          return onSuccess(jsonDecode(response.body));
        } else {
          logger.e('Failed to fetch data from API after cache miss.');
          return onError(Utils.handleError(response));
        }
      }
    } on Exception catch (e) {
      logger.e('Exception occurred: $e');
      return onError(e);
    }
  }
}

final DecisionRepositoryBackup decisionRepository = DecisionRepositoryBackup._(cacheRepository);
*/

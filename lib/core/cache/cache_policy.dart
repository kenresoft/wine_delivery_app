import 'package:vintiora/core/utils/constants.dart';

/// Defines caching policies for different API endpoints
class CachePolicy {
  // Map endpoints to their cache durations
  static final Map<String, Duration> cacheableEndpoints = {
    ApiConstants.checkAuth: const Duration(minutes: 1), // I used access token expiration time.
    ApiConstants.profile: const Duration(minutes: 10),
    ApiConstants.categories: Duration(seconds: 20),
    ApiConstants.orders: Duration(hours: 1),
  };

  /// Determines if an endpoint should be cached
  static bool shouldCache(String endpoint) {
    return cacheableEndpoints.containsKey(endpoint);
  }

  /// Get cache expiry duration for a specific endpoint, with a default value
  static Duration getExpiry(String endpoint) {
    return cacheableEndpoints[endpoint] ?? const Duration(minutes: 5);
  }

  /// Get cache policy for a specific endpoint
  static Map<String, dynamic> getForPath(String path) {
    return {
      'shouldCache': shouldCache(path),
      'expiry': getExpiry(path),
    };
  }
}

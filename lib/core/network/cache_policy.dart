import 'package:vintiora/features/auth/core/utils/constants.dart';

class CachePolicy {
  // Map endpoints to their cache durations
  static Map<String, Duration> cacheableEndpoints = {
    ApiConstants.profile: Duration(minutes: 10),
    ApiConstants.checkAuth: Duration(minutes: 5),
    // '/categories': Duration(hours: 1),
  };

  static bool shouldCache(String endpoint) {
    return cacheableEndpoints.containsKey(endpoint);
  }

  static Duration? getExpiry(String endpoint) {
    return cacheableEndpoints[endpoint];
  }
}

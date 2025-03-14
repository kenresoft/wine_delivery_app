class ApiConstants {
  static const String baseUrl = 'http://192.168.76.207:3333';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String profile = '/auth/profile';
  static const String checkAuth = '/auth/check';
  static const String refreshToken = '/auth/refresh';

  // List of endpoints that should be cached
  static final Set<String> cacheableEndpoints = {
    profile,
    checkAuth,
  };
}

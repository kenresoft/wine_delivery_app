import 'package:vintiora/core/config/environment_config.dart';

class Constants {
  Constants._();

  static const appName = 'Vintiora';

  static const empty = '';

  static const unknownDevice = 'Unknown device';

  static const String dbName = 'VintioraDb';

  static String baseUrl = '${EnvironmentConfig.baseUrl}/api';

  static String wsBaseUrl = EnvironmentConfig.wsBaseUrl;

  static String stripePublishableKey = EnvironmentConfig.stripeKey;

  static String imagePlaceholder = 'assets/images/${EnvironmentConfig.imagePlaceholder}';

  static const String wineImage = 'assets/images/wine-11.png';

  static const int tokenRefreshThreshold = 60;

  // Request timeouts
  static const int connectionTimeout = 5000; // 5 seconds

  static const int receiveTimeout = 3000; // 3 seconds
}

class ApiConstants {
  // Auth endpoints
  static String baseUrl = Constants.baseUrl;
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String profile = '/auth/profile';
  static const String checkAuth = '/auth/check';
  static const String refreshToken = '/auth/refresh';

  //
  static const String products = '/products';
  static const String categories = '/categories';
  static const String orders = '/orders';
}

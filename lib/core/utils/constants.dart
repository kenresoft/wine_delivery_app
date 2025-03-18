import 'package:vintiora/core/config/environment_config.dart';

class Constants {
  Constants._();

  static const String appName = 'Vintiora';

  static const String packageName = 'com.kenresoft.vintiora';

  static const String empty = '';

  static const String unknownDevice = 'Unknown device';

  static const String dbName = 'VintioraDb';

  static final String baseUrl = EnvironmentConfig.baseUrl;

  static final String wsBaseUrl = EnvironmentConfig.wsBaseUrl;

  static final String stripePublishableKey = EnvironmentConfig.stripeKey;

  static final String imagePlaceholder = 'assets/images/${EnvironmentConfig.imagePlaceholder}';

  static const String wineImage = 'assets/images/wine-11.png';

  static const int tokenRefreshThreshold = 60;

  // Request timeouts
  static const Duration connectionTimeout = Duration(seconds: 5);

  static const Duration receiveTimeout = Duration(seconds: 3);
}

class ApiConstants {
  static final String baseUrl = '${Constants.baseUrl}/api';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String profile = '/auth/profile';
  static const String checkAuth = '/auth/check';
  static const String refreshToken = '/auth/refresh';

  // Other endpoints
  static const String products = '/products';
  static const String categories = '/categories';
  static const String orders = '/orders';
}

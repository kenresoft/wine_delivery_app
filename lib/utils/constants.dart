import 'package:wine_delivery_app/utils/environment_config.dart';

class Constants {
  Constants._();

  static const empty = '';

  static const unknownDevice = 'Unknown device';

  static String baseUrl = EnvironmentConfig.baseUrl;

  static String wsBaseUrl = EnvironmentConfig.wsBaseUrl;

  static const int tokenRefreshThreshold = 60;

  static String stripePublishableKey = EnvironmentConfig.stripeKey;

  static String imagePlaceholder = 'assets/images/${EnvironmentConfig.imagePlaceholder}';

  static String wineImage = 'assets/images/wine-11.png';
}
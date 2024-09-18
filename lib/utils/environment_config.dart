import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  EnvironmentConfig._();

  static String? _baseUrl;
  static String? _wsBaseUrl;
  static String? _stripeKey;

  static Future<void> load(ConfigMode configMode) async {
    await dotenv.load(fileName: configMode == ConfigMode.prod ? '.env.prod' : '.env.dev');

    // Load environment variables without default fallback
    _baseUrl = dotenv.env['API_BASE_URL'];
    _wsBaseUrl = dotenv.env['WEBSOCKET_BASE_URL'];
    _stripeKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
  }

  static String get baseUrl {
    if (_baseUrl == null) {
      throw Exception('API Base URL is not set in the environment file.');
    }
    return _baseUrl!;
  }

  static String get wsBaseUrl {
    if (_wsBaseUrl == null) {
      throw Exception('WebSocket Base URL is not set in the environment file.');
    }
    return _wsBaseUrl!;
  }

  static String get stripeKey {
    if (_stripeKey == null) {
      throw Exception('Stripe Publishable Key is missing in the environment file.');
    }
    return _stripeKey!;
  }
}

enum ConfigMode {
  prod,
  dev,
}
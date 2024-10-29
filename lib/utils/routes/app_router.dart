import 'package:flutter/material.dart';

import '../../model/product.dart';
import '../../views/auth/login_page.dart';
import '../../views/auth/registration_page.dart';
import '../../views/category/products_category_screen.dart';
import '../../views/favorite/favorites.dart';
import '../../views/home/main_screen.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../../views/onboarding/splash_screen.dart';
import '../../views/product/product_detail_screen.dart';
import '../../views/shared/error_screen.dart';
import '../helpers.dart';

class AppRouter {
  Route? generateRoute(
    RouteSettings settings, {
    required Object? error,
    required Future<void> Function() onRetry,
  }) {
    return switch (settings.name) {
      Routes.error => MaterialPageRoute(
          builder: (_) => ErrorScreen(
            message: "Initialization failed: $error",
            errorType: ErrorType.initialization,
            onRetry: onRetry,
          ),
        ),
      Routes.splash => MaterialPageRoute(builder: (_) => SplashScreen()),
      Routes.onBoarding => MaterialPageRoute(builder: (_) => OnboardingScreen()),
      Routes.register => MaterialPageRoute(builder: (_) => RegistrationPage()),
      Routes.login => MaterialPageRoute(builder: (_) => LoginPage()),
      Routes.main => MaterialPageRoute(builder: (_) => MainScreen()),
      Routes.favorites => MaterialPageRoute(builder: (_) => FavoritesScreen()),
      Routes.products => MaterialPageRoute(builder: (_) => CategoryScreen()),

      // Handle product details route
      Routes.productDetails => MaterialPageRoute(
          builder: (_) {
            final product = settings.arguments;
            if (product == null || product is! Product) {
              return ErrorScreen(
                actionText: 'Back',
                message: 'Invalid product data',
                errorType: ErrorType.route,
                onRetry: () async => Nav.pop(),
                // onRetry: () async => Nav.navigateAndRemoveUntil(Routes.main),
              );
            }
            logger.w(product);
            return ProductDetailScreen(product: product);
          },
        ),
      _ => MaterialPageRoute(
          builder: (_) => ErrorScreen(
            message: 'No route defined for ${settings.name}',
            errorType: ErrorType.route,
            onRetry: () async => Nav.navigateAndRemoveUntil(Routes.main),
          ),
        )
    };
  }
}
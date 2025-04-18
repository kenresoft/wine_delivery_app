import 'package:flutter/material.dart';
import 'package:vintiora/core/router/routes.dart';
import 'package:vintiora/features/auth/presentation/pages/login_screen.dart';
import 'package:vintiora/features/auth/presentation/pages/register_screen.dart';
import 'package:vintiora/features/auth/presentation/pages/splash_screen.dart';
import 'package:vintiora/features/cart/presentation/pages/cart_screen.dart';
import 'package:vintiora/features/cart/shopping_cart.dart';
import 'package:vintiora/features/category/products_category_screen.dart';
import 'package:vintiora/features/favorite/favorites_screen.dart';
import 'package:vintiora/features/flash_sale/presentation/pages/flash_sale_details_page.dart';
import 'package:vintiora/features/flash_sale/presentation/pages/flash_sale_list_page.dart';
import 'package:vintiora/features/main/presentation/pages/main_screen.dart';
import 'package:vintiora/features/onboarding/onboarding_screen.dart';
import 'package:vintiora/features/order/data/models/responses/order.dart';
import 'package:vintiora/features/order/data/models/responses/order_product_item.dart';
import 'package:vintiora/features/order/presentation/pages/order_confirmation_screen.dart';
import 'package:vintiora/features/order/presentation/pages/order_tracking_screens.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
// import 'package:vintiora/features/product/data/models/responses/product.dart';
import 'package:vintiora/features/product/presentation/pages/product_detail_screen.dart';
import 'package:vintiora/features/promotion/domain/entities/promotion_entity.dart';
import 'package:vintiora/features/promotion/presentation/pages/promotion_page.dart';
import 'package:vintiora/features/promotion/presentation/widgets/promotion_detail_page.dart';
import 'package:vintiora/shared/components/error_page.dart';

import 'nav.dart';

class AppRouter {
  /// Centralized map of all route names and their corresponding widgets.
  /// I need to ensure each route is unique and registered here.
  static final Map<Routes, WidgetBuilder> routes = {
    // Intro Routes
    Routes.splash: (_) => const SplashScreen(),
    Routes.onBoarding: (_) => OnboardingScreen(),
    Routes.register: (_) => RegisterScreen(),
    Routes.login: (_) => LoginScreen(),
    // Routes.register: (_) => RegistrationPage(),
    // Routes.login: (_) => LoginPage(),

    // Main
    Routes.main: (_) => MainScreen(),
    Routes.favorites: (_) => FavoritesScreen(),
    Routes.products: (_) => CategoryScreen(),
    Routes.promotion: (_) => PromotionPage(),
    Routes.flashSale: (_) => FlashSaleListPage(),
    Routes.cart: (_) => CartScreen(),
  };

  /// Generates routes dynamically.
  Route<dynamic>? generateRoute(
    RouteSettings settings, {
    required Object? error,
    required Future<void> Function() onRetry,
  }) {
    final route = Routes.fromPath(settings.name ?? '');
    if (route == null) {
      return _errorRoute(settings.name);
    }

    if (route == Routes.error) {
      return MaterialPageRoute(
        builder: (_) => ErrorPage(
          message: "Initialization failed: $error",
          errorType: ErrorType.initialization,
          onRetry: onRetry,
        ),
      );
    }
    try {
      // Basic predefined routes
      if (routes.containsKey(route)) {
        return MaterialPageRoute(
          builder: routes[route]!,
          settings: settings,
        );
      }

      // Custom routes (with arguments)
      return _handleCustomRoutes(settings);
    } catch (e, st) {
      // Store failed route so we can retry it
      Nav.rememberFailedRoute(settings);

      return MaterialPageRoute(
        builder: (_) => ErrorPage(
          message: "Failed to load page: ${settings.name}",
          errorType: ErrorType.route,
          onRetry: () async {
            Nav.clearFailedRoute(); // Avoid loops
            await Nav.retryLastFailedRoute();
          },
        ),
      );
    }
  }

  /// Handles non-standard routes with additional arguments or validation.
  Route<dynamic>? _handleCustomRoutes(RouteSettings settings) {
    final route = Routes.fromPath(settings.name ?? '');
    if (route == null) {
      return _errorRoute(settings.name);
    }

    return switch (route) {
      Routes.productDetails => _buildRoute((context) {
          return ProductDetailScreen(productId: _getArgOrDefault<String>(settings.arguments));
        }, settings),
      Routes.promotionDetails => _buildRoute((context) {
          return PromotionDetailPage(promotionWithProducts: _getArgOrDefault<PromotionWithProductsEntity>(settings.arguments));
        }, settings),
      Routes.flashSaleDetails => _buildRoute((context) {
          return FlashSaleDetailsPage(flashSaleId: _getArgOrDefault<String>(settings.arguments));
        }, settings),
      Routes.orderConfirmation => _buildRoute((context) {
          try {
            final args = _getArgOrDefault<Map<String, dynamic>>(settings.arguments);
            final order = args['order'] as Order?;
            final orderedItems = args['items'] as List<OrderProductItem>?;
            if (order != null && orderedItems != null) {
              return OrderConfirmationScreen(order: order, orderedItems: orderedItems);
            }
          } catch (_) {}
          return errorScreen;
        }, settings),
      Routes.orderTracking => _buildRoute((context) {
          return OrderTrackingScreen(order: _getArgOrDefault<Order>(settings.arguments));
        }, settings),

      // Undefined routes
      _ => _errorRoute(settings.name),
    };
  }

  /// Builds an error route for undefined paths.
  Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => ErrorPage(
        message: 'No route defined for $routeName',
        errorType: ErrorType.route,
        actionText: 'Back',
        onRetry: () async => Nav.pop(),
        // onRetry: () async => Nav.navigateAndRemoveUntil(Routes.main),
      ),
    );
  }

  Route<dynamic> _buildRoute(WidgetBuilder builder, RouteSettings? settings) {
    return MaterialPageRoute(builder: builder, settings: settings);
  }

  /// Retrieves the argument if it matches the expected type or returns the default value.
  /// Throws an error if the argument is invalid and no default value is provided.
  T _getArgOrDefault<T>(Object? arguments, {T? defaultValue}) {
    if (arguments is T) return arguments;
    if (defaultValue != null) return defaultValue;
    throw ArgumentError('Expected argument of type $T but got ${arguments.runtimeType}');
  }

  ErrorPage get errorScreen {
    return ErrorPage(
      actionText: 'Back',
      message: 'Invalid page data',
      errorType: ErrorType.route,
      onRetry: () async => Nav.pop(),
      // onRetry: () async => Nav.navigateAndRemoveUntil(Routes.main),
    );
  }
}

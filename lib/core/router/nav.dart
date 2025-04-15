import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vintiora/core/router/app_router.dart';
import 'package:vintiora/core/router/page_transition.dart';
import 'package:vintiora/core/router/routes.dart';

import 'analytics_observer.dart';
import 'state_observer.dart';

class Nav {
  static final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  static final StateObserver stateObserver = StateObserver();

  static final AnalyticsObserver analyticsObserver = AnalyticsObserver(); // For Analytics

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void _handleNavigationError(String message, {Object? error}) {
    log('Navigation Error: $message', name: 'Nav', error: error);
  }

  static BuildContext? get navContext {
    try {
      final context = navigatorKey.currentState?.context;
      if (context != null) return context;

      if (kReleaseMode) {
        log('Navigator context is null.', name: 'Nav');
        return null;
      }
      throw NavigatorError('Navigator context is null. Unable to navigate.');
    } catch (e) {
      _handleNavigationError('Failed to get main context', error: e);
      rethrow;
    }
  }

  // Handle Failed Routes
  static RouteSettings? _lastFailedRoute;

  static void rememberFailedRoute(RouteSettings settings) {
    _lastFailedRoute = settings;
  }

  static Future<void> retryLastFailedRoute() async {
    if (_lastFailedRoute != null) {
      navigatorKey.currentState?.pushReplacementNamed(
        _lastFailedRoute!.name!,
        arguments: _lastFailedRoute!.arguments,
      );
    }
  }

  static void clearFailedRoute() {
    _lastFailedRoute = null;
  }

  // Navigation methods
  static void push(Routes route, {Object? arguments}) {
    try {
      log('Navigating to ${route.path} with arguments: $arguments', name: 'Nav');

      final navigator = navigatorKey.currentState;
      if (navigator == null) {
        throw NavigatorError('Navigator state is null');
      }

      navigator.pushNamed(route.path, arguments: arguments);
    } catch (e) {
      _handleNavigationError('Failed to push route: ${route.path}', error: e);
      rethrow;
    }
  }

  static void pushReplace(Routes route, {Object? arguments}) {
    try {
      log('Replacing current route with ${route.path}', name: 'Nav');

      final navigator = navigatorKey.currentState;
      if (navigator == null) {
        throw NavigatorError('Navigator state is null');
      }

      navigator.pushReplacementNamed(route.path, arguments: arguments);
    } catch (e) {
      _handleNavigationError('Failed to replace route with: ${route.path}', error: e);
      rethrow;
    }
  }

  static void pop({Routes fallbackRoute = Routes.main, Object? arguments}) {
    try {
      final navigator = navigatorKey.currentState;
      if (navigator == null) {
        throw NavigatorError('Navigator state is null');
      }

      // Check if we're not at the root before popping
      if (navigator.canPop()) {
        navigator.pop();
      } else {
        log('Cannot pop — already at root. Redirecting to ${fallbackRoute.path}', name: 'Nav');

        // Optionally prevent redundant redirection
        final currentRoute = ModalRoute.of(navigator.context)?.settings.name;
        if (currentRoute != fallbackRoute.path) {
          navigator.pushReplacementNamed(fallbackRoute.path, arguments: arguments);
        } else {
          log('Already at fallback/root route: ${fallbackRoute.path}', name: 'Nav');
        }
      }
    } catch (e) {
      _handleNavigationError('Failed to pop or redirect to fallback route', error: e);
      rethrow;
    }
  }

  static void popTo(Routes route) {
    try {
      log('Popping until route: ${route.path}', name: 'Nav');

      final navigator = navigatorKey.currentState;
      if (navigator == null) {
        throw NavigatorError('Navigator state is null');
      }

    // Check if we're already at the target route
    if (ModalRoute.of(navigator.context)?.settings.name == route.path) {
      log('Already at target route: ${route.path}', name: 'Nav');
      return;
    }

    // Check if we're trying to pop to root when we're already at root
    if (route == Routes.main && !navigator.canPop()) {
      log('Cannot pop to root when already at root', name: 'Nav');
      return;
    }

      navigator.popUntil(ModalRoute.withName(route.path));
    } catch (e) {
      _handleNavigationError('Failed to pop to route: ${route.path}', error: e);
      rethrow;
    }
  }

  static void popAndPush(Routes route, {Object? arguments}) {
    try {
      log('Popping current route and pushing: ${route.path}', name: 'Nav');

      final navigator = navigatorKey.currentState;
      if (navigator == null) {
        throw NavigatorError('Navigator state is null');
      }

      if (navigator.canPop()) {
        navigator.popAndPushNamed(route.path, arguments: arguments);
      } else {
        // If we can't pop, just push the new route
        navigator.pushNamed(route.path, arguments: arguments);
      }
    } catch (e) {
      _handleNavigationError('Failed to pop and push route: ${route.path}', error: e);
      rethrow;
    }
  }

  static void navigateAndRemoveUntil(Routes route, {bool Function(Route<dynamic>)? predicate, Object? arguments}) {
    try {
      log('Navigating to ${route.path} and removing all previous routes', name: 'Nav');

      final navigator = navigatorKey.currentState;
      if (navigator == null) {
        throw NavigatorError('Navigator state is null');
      }
      navigator.pushNamedAndRemoveUntil(
        route.path,
        predicate ?? (r) => r.settings.name == route.path,
        arguments: arguments,
      );
    } catch (e) {
      _handleNavigationError('Failed to navigate and remove until: ${route.path}', error: e);
      rethrow;
    }
  }

  /// Pushes a route with custom transition
  static Future<T?> pushWithTransition<T extends Object?>(
    Routes route, {
    Widget? page,
    PageTransitionConfig? transitionConfig,
    Object? arguments,
  }) {
    try {
      final navigator = navigatorKey.currentState;
      if (navigator == null) {
        throw NavigatorError('Navigator state is null');
      }

      final config = transitionConfig ?? PageTransitionConfig.fade();
      final routeName = route.path;

      return navigator.push(
        PageRouteBuilder(
          settings: RouteSettings(name: routeName, arguments: arguments),
          pageBuilder: (context, animation, secondaryAnimation) {
            final widgetBuilder = AppRouter.routes[route];
            if (widgetBuilder == null && page == null) {
              throw NavigatorError('No widget builder found for route: $routeName and no fallback widget provided');
            }
            return widgetBuilder != null ? widgetBuilder(context) : page!;
          },
          transitionsBuilder: config.transitionsBuilder ?? (context, animation, secondaryAnimation, child) => child,
          transitionDuration: config.duration,
        ),
      );
    } catch (e) {
      _handleNavigationError('Failed to push route with transition', error: e);
      rethrow;
    }
  }

  /// Pushes and replaces current route with custom transition
  static Future<T?> pushReplaceWithTransition<T extends Object?, TO extends Object?>(
    Routes route, {
    Widget? page,
    PageTransitionConfig? transitionConfig,
    Object? arguments,
    TO? result,
  }) {
    try {
      final navigator = navigatorKey.currentState;
      if (navigator == null) {
        throw NavigatorError('Navigator state is null');
      }

      final config = transitionConfig ?? PageTransitionConfig.fade();
      final routeName = route.path;

      return navigator.pushReplacement(
        PageRouteBuilder(
          settings: RouteSettings(name: routeName, arguments: arguments),
          pageBuilder: (context, animation, secondaryAnimation) {
            final widgetBuilder = AppRouter.routes[route];
            if (widgetBuilder == null && page == null) {
              throw NavigatorError('No widget builder found for route: $routeName and no fallback widget provided');
            }
            return widgetBuilder != null ? widgetBuilder(context) : page!;
          },
          transitionsBuilder: config.transitionsBuilder ?? (context, animation, secondaryAnimation, child) => child,
          transitionDuration: config.duration,
        ),
        result: result,
      );
    } catch (e) {
      _handleNavigationError('Failed to push replacement route with transition', error: e);
      rethrow;
    }
  }

  /// Displays a toast message.
  static void showToast(String message, {ToastGravity gravity = ToastGravity.BOTTOM}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
    );
  }

  /// Displays a snackBar.
  static void showSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
        ),
      );
    }
  }

  /// Displays a snackBar.
  static void showCustomSnackBar(SnackBar snackBar) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// Displays an overlay banner.
  static void showBanner(
    String message, {
    String? title, // Optional title
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.black,
    double backgroundOpacity = 0.5,
    double blurStrength = 6.0,
    TextStyle textStyle = const TextStyle(color: Colors.white),
    TextStyle titleStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    double topPadding = 0.0,
  }) {
    final navigatorState = navigatorKey.currentState;
    if (navigatorState == null) return;

    // Ensure we use the Navigator's context for the Overlay
    final overlay = navigatorState.overlay;
    if (overlay == null) return;

    // State controller for animation
    OverlayEntry? overlayEntry;
    bool isVisible = true;
    Offset positionOffset = const Offset(0, -1); // Start above the screen
    bool isDragging = false; // Tracks whether the user is dragging
    Timer? autoDismissTimer; // Timer for auto-dismiss

    // Function to start the auto-dismiss timer
    void startAutoDismissTimer() {
      autoDismissTimer = Timer(duration, () {
        if (!isDragging && overlayEntry != null) {
          isVisible = false;
          positionOffset = const Offset(0, -1); // Slide out of view
          overlayEntry?.markNeedsBuild();
          Future.delayed(const Duration(milliseconds: 500), () {
            overlayEntry?.remove();
            overlayEntry = null;
          });
        }
      });
    }

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 10 + topPadding, // Adjust position based on status bar
          left: 20,
          right: 20,
          child: StatefulBuilder(
            builder: (context, setState) {
              return GestureDetector(
                onTap: () {
                  // Dismiss on tap
                  autoDismissTimer?.cancel();
                  isVisible = false;
                  positionOffset = const Offset(0, -1);
                  overlayEntry?.markNeedsBuild();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    overlayEntry?.remove();
                    overlayEntry = null;
                  });
                },
                onVerticalDragStart: (_) {
                  // Pause auto-dismiss when dragging starts
                  isDragging = true;
                  autoDismissTimer?.cancel();
                },
                onVerticalDragUpdate: (details) {
                  // Adjust position during drag
                  if (details.primaryDelta != null) {
                    setState(() {
                      positionOffset += Offset(0, details.primaryDelta! / 100);
                    });
                  }
                },
                onVerticalDragEnd: (details) {
                  // Check if dragged far enough to dismiss
                  if (positionOffset.dy > 0.5) {
                    isVisible = false;
                    positionOffset = const Offset(0, -1);
                    overlayEntry?.markNeedsBuild();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      overlayEntry?.remove();
                      overlayEntry = null;
                    });
                  } else {
                    // Reset position if not dragged enough
                    setState(() {
                      positionOffset = Offset.zero;
                    });

                    // Resume auto-dismiss if touch released
                    isDragging = false;
                    startAutoDismissTimer();
                  }
                },
                child: AnimatedOpacity(
                  opacity: isVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: AnimatedSlide(
                    offset: positionOffset,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    child: Material(
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
                              child: Container(
                                color: backgroundColor.withValues(alpha: backgroundOpacity),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Display title if provided
                                    if (title != null)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          title,
                                          style: titleStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    // Display message
                                    Text(
                                      message,
                                      style: textStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    // Insert the overlay entry
    overlay.insert(overlayEntry!);

    // Trigger slide-in and fade-in animations
    Future.delayed(const Duration(milliseconds: 50), () {
      if (overlayEntry != null) {
        positionOffset = Offset.zero; // Slide into view
        overlayEntry?.markNeedsBuild();
      }
    });

    // Start the auto-dismiss timer initially
    startAutoDismissTimer();
  }

  /// Displays a bottom sheet.
  static void showBottomSheet(WidgetBuilder builder, {bool isDismissible = true}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      showModalBottomSheet(
        context: context,
        builder: builder,
        isScrollControlled: true,
        isDismissible: isDismissible,
      );
    }
  }

  /// Displays a modal dialog.
  static Future<void> showModal(WidgetBuilder builder) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      await showDialog(
        context: context,
        builder: builder,
      );
    }
  }

  /// Displays an alert dialog.
  static Future<void> showAlert({
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              if (cancelText != null)
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    onCancel?.call();
                  },
                  child: Text(cancelText),
                ),
              if (confirmText != null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    onConfirm?.call();
                  },
                  child: Text(confirmText),
                ),
            ],
          );
        },
      );
    }
  }
}

class NavigatorError extends Error {
  final String message;

  NavigatorError(this.message);

  @override
  String toString() => 'NavigatorError: $message';
}

final navContext = Nav.navContext;

extension ContextExtension on BuildContext {
  bool get current => ModalRoute.of(this)?.isCurrent == true;

  bool get active => ModalRoute.of(this)?.isActive == true;
}

import 'package:flutter/material.dart';

class Nav {
  static final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static bool? get isCurrent {
    final context = navigatorKey.currentState?.context;
    if (context != null) {
      return ModalRoute.of(context)?.isCurrent;
    } else {
      return false;
    }
  }

  /// Pushes a new screen onto the stack.
  static void push(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  /// Pushes a new screen and replaces the current screen.
  static void pushReplace(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Pops the current screen from the stack.
  static void pop() {
    navigatorKey.currentState?.pop();
  }

  /// Pops until reaching a specified route.
  static void popTo(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }

  /// Pops the current screen and pushes a new screen.
  static void popAndPush(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.popAndPushNamed(routeName, arguments: arguments);
  }

  /// Pushes a new screen and removes all previous screens until the specified one.
  static void navigateAndRemoveUntil(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }
}

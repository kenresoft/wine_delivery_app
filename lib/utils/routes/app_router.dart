// lib/utils/app_router.dart
import 'package:flutter/material.dart';
import '../screens/screen_a.dart';
import '../screens/screen_b.dart';
import '../screens/screen_c.dart';
import '../screens/screen_e.dart';
import '../screens/screen_f.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.screenA:
        return MaterialPageRoute(builder: (_) => ScreenA());
      case Routes.screenB:
        return MaterialPageRoute(builder: (_) => ScreenB());
      case Routes.screenC:
        return MaterialPageRoute(builder: (_) => ScreenC());
      case Routes.screenE:
        return MaterialPageRoute(builder: (_) => ScreenE());
      case Routes.screenF:
        return MaterialPageRoute(builder: (_) => ScreenF());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

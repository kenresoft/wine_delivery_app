import 'package:flutter/widgets.dart';

class AnalyticsObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _logScreen(route.settings.name);
  }

  void _logScreen(String? screenName) {
    debugPrint("Screen tracked: $screenName");
    // Add analytics tracking logic here.
  }
}

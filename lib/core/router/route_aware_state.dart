import 'package:flutter/material.dart';
import 'package:vintiora/core/router/nav.dart';

/// A base class for screens that need to be aware of navigation transitions,
/// such as reloading data when the screen becomes visible again.
abstract class RouteAwareState<T extends StatefulWidget> extends State<T> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      Nav.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    Nav.routeObserver.unsubscribe(this);
    super.dispose();
  }

  void onReturnToScreen() {}

  @override
  void didPopNext() {
    onReturnToScreen();
  }

  @override
  void didPush() {}

  @override
  void didPushNext() {}

  @override
  void didPop() {}
}

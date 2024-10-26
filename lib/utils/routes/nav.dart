import 'package:flutter/material.dart';

class Nav {
  static void push(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void pushReplace(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  static void popTo(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  static void popAndPush(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.popAndPushNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndRemoveUntil(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false, arguments: arguments);
  }

/*  static void navigateToScreenAIfNavigatedFromB(BuildContext context) {
    Navigator.popUntil(context, (route) {
      return route.settings.name == Routes.screenA || route.settings.name == Routes.screenB;
    });
  }*/
}

// simple_route_information_parser.dart
import 'package:flutter/material.dart';

import '../bloc/route/route_state.dart';

class SimpleRouteInformationParser extends RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.uri.path);
    if (uri.pathSegments.isEmpty) {
      return HomePageState();
    }

    switch (uri.pathSegments.first) {
      case 'home':
        return HomePageState();
      case 'categories':
        return CategoriesPageState();
      case 'cart':
        return CartPageState();
      case 'profile':
        return ProfilePageState();
      default:
        return HomePageState();
    }
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    if (configuration is HomePageState) {
      return RouteInformation(uri: Uri.parse('/home'));
    } else if (configuration is CategoriesPageState) {
      return RouteInformation(uri: Uri.parse('/categories'));
    } else if (configuration is CartPageState) {
      return RouteInformation(uri: Uri.parse('/cart'));
    } else if (configuration is ProfilePageState) {
      return RouteInformation(uri: Uri.parse('/profile'));
    }
    return null;
  }
}

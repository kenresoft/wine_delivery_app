// tab_router_delegate.dart
import 'package:flutter/material.dart';
import 'package:wine_delivery_app/views/cart/cart_page.dart';
import 'package:wine_delivery_app/views/cart/shopping_cart.dart';
import 'package:wine_delivery_app/views/category/category_screen.dart';
import 'package:wine_delivery_app/views/home/home_screen.dart';

import '../bloc/route/route_bloc.dart';
import '../bloc/route/route_state.dart';

class TabRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationState> {
  final GlobalKey<NavigatorState> navigatorKey;
  final NavigationBloc navigationBloc;

  TabRouterDelegate(this.navigationBloc) : navigatorKey = GlobalKey<NavigatorState>() {
    navigationBloc.stream.listen((_) => notifyListeners());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Navigator(
        key: navigatorKey,
        pages: [
          if (navigationBloc.state is HomePageState)
            MaterialPage(child: HomeScreen()),
          if (navigationBloc.state is CategoriesPageState)
            MaterialPage(child: CategoryScreen()),
          if (navigationBloc.state is CartPageState)
            MaterialPage(child: CartPage()),
          if (navigationBloc.state is ProfilePageState)
            MaterialPage(child: ShoppingCartScreen()),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
    // Do nothing, as we are handling navigation through Bloc.
  }

  @override
  NavigationState? get currentConfiguration => navigationBloc.state;
}

// tab_router_delegate.dart
import 'package:flutter/material.dart';
import 'package:wine_delivery_app/views/cart/cart_page.dart';
import 'package:wine_delivery_app/views/cart/shopping_cart.dart';
import 'package:wine_delivery_app/views/category/products_category_screen.dart';
import 'package:wine_delivery_app/views/home/home_screen.dart';

import '../bloc/route/route_bloc.dart';
import '../bloc/route/route_state.dart';

class TabRouterDelegate extends RouterDelegate<NavigationState> with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final NavigationBloc navigationBloc;

  TabRouterDelegate(this.navigationBloc) : navigatorKey = GlobalKey<NavigatorState>() {
    navigationBloc.stream.listen((_) => notifyListeners());
  }

  //@override
  //Future<bool> popRoute() async {
  /*final shouldPop = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );*/

  /*return shouldPop ?? false*/
  //}

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (navigationBloc.state is HomePageState) MaterialPage(child: HomeScreen()),
        if (navigationBloc.state is CategoriesPageState) MaterialPage(child: CategoryScreen()),
        if (navigationBloc.state is CartPageState) MaterialPage(child: CartPage()),
        if (navigationBloc.state is ProfilePageState) MaterialPage(child: ShoppingCartScreen()),
      ],
      onDidRemovePage: (page) {
        print(page);
        // Handle your custom pop logic
        //_stack.removeLast();
        notifyListeners();
        //return true;
      },
      /*onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },*/
    );
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
    // Do nothing, as we are handling navigation through Bloc.
  }

  @override
  NavigationState? get currentConfiguration => navigationBloc.state;
}

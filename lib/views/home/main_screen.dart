import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wine_delivery_app/utils/extensions.dart';

import '../../bloc/navigation/bottom_navigation_bloc.dart';
import '../../utils/globals.dart';
import '../../utils/routes/nav.dart';
import '../cart/shopping_cart.dart';
import '../category/products_category_screen.dart';
import '../order/order_history.dart';
import '../user/user_profile_screen.dart';
import 'app_exit_dialog.dart';
import 'home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final List<Widget> _pages = const [
    HomeScreen(),
    // Home(),
    CategoryScreen(),
    ShoppingCartScreen(),
    OrderHistoryScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        /*int currentIndex = 0;
        if (state is PageChanged) {
          currentIndex = state.selectedIndex;
        }*/

        return Scaffold(
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              /*if (state.selectedIndex != 0) {
                BlocProvider.of<NavigationBloc>(context).add(const PageTapped(0));
              } else {*/
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AppExitDialog(
                    title: 'Exit App?',
                    message: 'Are you sure you want to exit the app?',
                      confirmButtonText: 'Exit',
                      cancelButtonText: 'Cancel',
                      onConfirm: () {
                      Nav.pop();
                      if (isAndroid) {
                        SystemNavigator.pop();
                      } else if (isIOS) {
                        exit(0);
                      }
                    },
                    onCancel: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              // }
            },
            child: _pages[state.selectedIndex],
            /*child: IndexedStack(
              index: currentIndex,
              children: _pages,
            ),*/
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: FontAwesomeIcons.house.ic,
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FontAwesomeIcons.magnifyingGlass.ic,
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: FontAwesomeIcons.cartShopping.ic,
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: FontAwesomeIcons.cartFlatbed.ic,
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: FontAwesomeIcons.solidUser.ic,
                label: 'Profile',
              ),
            ],
            currentIndex: state.selectedIndex,
            // selectedItemColor: Colors.amber[800],
            onTap: (index) {
              BlocProvider.of<NavigationBloc>(context).add(PageTapped(index));
            },
          ),
        );
      },
    );
  }
}

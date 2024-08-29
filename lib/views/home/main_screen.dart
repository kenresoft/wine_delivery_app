import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/views/home/home.dart';
import 'package:wine_delivery_app/views/home/home_screen.dart';
import 'package:wine_delivery_app/views/user/user_profile_screen.dart';

import '../../bloc/navigation/bottom_navigation_bloc.dart';
import '../product/cart/shopping_cart.dart';
import 'app_exit_dialog.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final List<Widget> _pages = const [
    HomeScreen(),
    Home(),
    ShoppingCartScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is PageChanged) {
          currentIndex = state.selectedIndex;
        }

        return Scaffold(
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (currentIndex != 0) {
                BlocProvider.of<NavigationBloc>(context).add(const PageTapped(0));
              } else {
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
                        // Handle exit logic
                        Navigator.pop(context);
                      },
                      onCancel: () {
                        // Handle cancel logic
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              }
            },
            child: IndexedStack(
              index: currentIndex,
              children: _pages,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: currentIndex,
            selectedItemColor: Colors.amber[800],
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              BlocProvider.of<NavigationBloc>(context).add(PageTapped(index));
            },
          ),
        );
      },
    );
  }
}

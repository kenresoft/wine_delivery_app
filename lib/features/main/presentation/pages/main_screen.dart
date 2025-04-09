import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/utils/utils.dart';
import 'package:vintiora/features/cart/shopping_cart.dart';
import 'package:vintiora/features/category/products_category_screen.dart';
import 'package:vintiora/features/home/presentation/pages/home_page.dart';
import 'package:vintiora/features/home/presentation/widgets/app_exit_dialog.dart';
import 'package:vintiora/features/main/presentation/bloc/navigation/bottom_navigation_bloc.dart';
import 'package:vintiora/features/main/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:vintiora/features/order/presentation/widgets/order_history.dart';
import 'package:vintiora/features/user/presentation/pages/user_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _pages = const [
    HomePage(),
    // HomeScreen(),
    CategoryScreen(),
    ShoppingCartScreen(),
    OrderHistoryScreen(),
    UserProfileScreen(),
  ];

  final ValueNotifier<bool> _isBottomNavVisible = ValueNotifier(true);
  double _lastScrollOffset = 0;
  int? _currentPageIndex;

  @override
  void dispose() {
    _isBottomNavVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        final currentIndex = state.selectedIndex;
        final isSpecialPage = currentIndex == 1 || currentIndex == 3;

        // Reset nav visibility when page changes
        if (_currentPageIndex != currentIndex) {
          _isBottomNavVisible.value = !isSpecialPage;
          _lastScrollOffset = 0;
          _currentPageIndex = currentIndex;
        }

        return Scaffold(
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              if (isSpecialPage) {
                BlocProvider.of<NavigationBloc>(context).add(const PageTapped(0));
                return;
              }

              final shouldExit = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AppExitDialog(
                      title: 'Exit App?',
                      message: 'Are you sure you want to exit the app?',
                      confirmButtonText: 'Exit',
                      cancelButtonText: 'Cancel',
                      onConfirm: () => Navigator.pop(context, true),
                      onCancel: () => Navigator.pop(context, false),
                    ),
                  ) ??
                  false;

              if (shouldExit) {
                if (isAndroid) {
                  SystemNavigator.pop();
                } else if (isIOS) {
                  exit(0);
                }
              }
            },
            child: Stack(
              children: [
                NotificationListener<ScrollUpdateNotification>(
                  onNotification: (notification) {
                    if (isSpecialPage) return false;

                    // Only respond to vertical scrolls
                    if (notification.metrics.axis != Axis.vertical) return false;

                    final currentOffset = notification.metrics.pixels;
                    final scrollDelta = currentOffset - _lastScrollOffset;

                    // Only trigger on meaningful scroll (threshold of 5 pixels)
                    if (scrollDelta.abs() > 5) {
                      if (scrollDelta > 0 && _isBottomNavVisible.value) {
                        _isBottomNavVisible.value = false;
                      } else if (scrollDelta < 0 && !_isBottomNavVisible.value) {
                        _isBottomNavVisible.value = true;
                      }
                      _lastScrollOffset = currentOffset;
                    }
                    return false;
                  },
                  child: _pages[currentIndex],
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _isBottomNavVisible,
                  builder: (context, isVisible, child) {
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      bottom: isSpecialPage ? -100 : (isVisible ? 0 : -100),
                      left: 0,
                      right: 0,
                      child: child!,
                    );
                  },
                  child: CustomBottomNavigationBar(
                    currentIndex: currentIndex,
                    onTap: (index) {
                      BlocProvider.of<NavigationBloc>(context).add(PageTapped(index));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

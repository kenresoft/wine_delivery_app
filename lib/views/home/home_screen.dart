import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/navigation/bottom_navigation_bloc.dart';
import '../auth/registration_page.dart';
import 'category_grid.dart';
import 'featured_wine.dart';
import 'top_picks.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //productManager.getAllProducts();
    return Scaffold(
      appBar: _buildAppBar(context),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FeaturedWinesCarousel(),
              SizedBox(height: 20),
              CategoryGrid(),
              SizedBox(height: 10),
              TopPicksSection(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    context.read<CartBloc>().add(GetCartItems());
    return AppBar(
      title: const Text('Wine Delivery'),
      actions: [
        IconButton(
          icon: const Icon(Icons.login),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const RegistrationPage();
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Implement notification functionality
          },
        ),
        GestureDetector(
          onTap: () => BlocProvider.of<NavigationBloc>(context).add(const PageTapped(2)),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.shopping_cart, size: 24.r, color: const Color(0xff383838)),
                Positioned(
                  right: 0,
                  top: 0,
                  child: _buildCartBadge(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartBadge(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          return Container(
            alignment: Alignment.center,
            width: 16.w,
            height: 16.w,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: const Color(0xffBD7879),
              borderRadius: BorderRadius.circular(40),
            ),
            child: FittedBox(
              child: Text(
                '${state.cartItems.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          );
        } else {
          return Container(
              /*alignment: Alignment.center,
            width: 16.w,
            height: 16.w,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: const Color(0xffBD7879),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const FittedBox(
              child: Text(
                '0',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),*/
              );
        }
      },
    );
  }
}
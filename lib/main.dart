import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/bloc/category/favorite/favorite_bloc.dart';
import 'package:wine_delivery_app/bloc/profile/profile_bloc.dart';

import 'bloc/carousel/carousel_bloc.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/category/category_filter/category_filter_bloc.dart';
import 'bloc/category/category_list/wines_bloc.dart';
import 'bloc/navigation/bottom_navigation_bloc.dart';
import 'bloc/order/order_bloc.dart';
import 'bloc/shipping_address/shipping_address_bloc.dart';
import 'utils/app_theme.dart';
import 'views/admin/oder_management_page.dart';
import 'views/home/home.dart';
import 'views/home/home_screen.dart';
import 'views/product/cart/cart_page.dart';
import 'views/product/category/products_category_screen.dart';
import 'views/product/product_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 825),
      minTextAdapt: true,
      ensureScreenSize: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>(create: (context) => NavigationBloc()),
          BlocProvider<CartBloc>(create: (context) => CartBloc()),
          BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
          BlocProvider<ShippingAddressBloc>(create: (context) => ShippingAddressBloc()),
          BlocProvider<CarouselBloc>(create: (context) => CarouselBloc()),
          BlocProvider<CategoryFilterBloc>(create: (context) => CategoryFilterBloc()),
          BlocProvider<WinesBloc>(create: (context) => WinesBloc()),
          BlocProvider<FavoriteBloc>(create: (context) => FavoriteBloc()),
          BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme().themeData,
          routes: {
            '/': (context) => const HomeScreen(),
            // '/': (context) => OrderConfirmationScreen(),
            // '/': (context) => ShoppingCartScreen(),
            'home': (context) => const Home(),
            'product_page': (context) => const ProductPage(),
            'cart_page': (context) => const CartPage(),
            //'order_page': (context) => const OrderPage(),
            'order_management_page': (context) => const OrderManagementPage(),
            'category': (context) => const CategoryScreen(),
          },
        ),
      ),
    );
  }
}

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/bloc/cart/cart_bloc.dart';
import 'package:wine_delivery_app/bloc/order/order_bloc.dart';
import 'package:wine_delivery_app/bloc/shipping_address/shipping_address_bloc.dart';
import 'package:wine_delivery_app/utils/app_theme.dart';
import 'package:wine_delivery_app/views/admin/oder_management_page.dart';
import 'package:wine_delivery_app/views/cart/cart_page.dart';
import 'package:wine_delivery_app/views/home/home.dart';
import 'package:wine_delivery_app/views/product/product_page.dart';

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
          BlocProvider<CartBloc>(create: (context) => CartBloc()),
          BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
          BlocProvider<ShippingAddressBloc>(create: (context) => ShippingAddressBloc())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme().themeData,
          routes: {
            '/': (context) => const Home(),
            'product_page': (context) => const ProductPage(),
            'cart_page': (context) => const CartPage(),
            //'order_page': (context) => const OrderPage(),
            'order_management_page': (context) => const OrderManagementPage(),
          },
        ),
      ),
    );
  }
}

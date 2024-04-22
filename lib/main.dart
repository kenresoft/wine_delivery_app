import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontresoft/fontresoft.dart';
import 'package:wine_delivery_app/views/admin/oder_management_page.dart';
import 'package:wine_delivery_app/views/cart/cart_page.dart';
import 'package:wine_delivery_app/views/home/home.dart';
import 'package:wine_delivery_app/views/product/product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 825),
      minTextAdapt: true,
      ensureScreenSize: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
          fontFamily: FontResoft.poppins,
          textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xff252525))),
          package: FontResoft.package,
        ),
        routes: {
          '/': (context) => const Home(),
          'product_page': (context) => const ProductPage(),
          'cart_page': (context) => const CartPage(),
          'order_management_page': (context) => const OrderManagementPage(),
        },
        //home: const Home(),
      ),
    );
  }
}

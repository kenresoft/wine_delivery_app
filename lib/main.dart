import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontresoft/fontresoft.dart';
import 'package:wine_delivery_app/page_1/home.dart';
import 'package:wine_delivery_app/page_2/product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(448, 998),
      minTextAdapt: false,
      ensureScreenSize: false,
      useInheritedMediaQuery: true,
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
        },
        //home: const Home(),
      ),
    );
  }
}

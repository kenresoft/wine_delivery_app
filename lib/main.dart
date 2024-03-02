import 'package:flutter/material.dart';
import 'package:fontresoft/fontresoft.dart';
import 'package:wine_delivery_app/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        fontFamily: FontResoft.poppins,
        package: FontResoft.package,
      ),
      home: const Home(),
    );
  }
}

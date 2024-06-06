import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fontresoft/fontresoft.dart';

class AppTheme {
  AppTheme();

  final ThemeData themeData = ThemeData(
    primaryColor: const Color(0xff394346),
    primaryColorDark: const Color(0xffBD7879),
    scaffoldBackgroundColor: const Color(0xFFFAF9F6),
    fontFamily: FontResoft.poppins,
    package: FontResoft.package,
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xff394346))),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff394346),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xff394346),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xffBD7879),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(
          color: Color(0xffB3BDC0),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffB3BDC0) /*Color(0xff394346)*/,
          width: 2,
        ),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xffBD7879),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xffF4F4F4),
      surfaceTintColor: const Color(0xffF4F4F4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xffB3BDC0), width: 1),
      ),
      elevation: 0,
    ),
    brightness: Brightness.light,
    iconTheme: const IconThemeData(color: Color(0xff394346)),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff394346),
    ).copyWith(
      primary: const Color(0xff394346),
      primaryContainer: const Color(0xff687A80),
      secondary: const Color(0xffBD7879),
      tertiary: const Color(0xffB3BDC0),
      surface: const Color(0xFFFAF9F6),
      surfaceTint: const Color(0xffF4F4F4),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFFAF9F6),
      selectedItemColor: Color(0xff394346),
      unselectedItemColor: Color(0xffB3BDC0),
      selectedIconTheme: IconThemeData(
        color: Color(0xff394346),
      ),
      unselectedIconTheme: IconThemeData(
        color: Color(0xffB3BDC0),
      ),
      selectedLabelStyle: TextStyle(color: Color(0xff394346)),
      unselectedLabelStyle: TextStyle(color: Color(0xffB3BDC0)),
      showUnselectedLabels: true,
    ),
  );
}

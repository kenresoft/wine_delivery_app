import 'package:flutter/material.dart';
import 'package:fontresoft/fontresoft.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    primaryColor: const Color(0xffBD7879),
    primaryColorDark: const Color(0xff394346),
    scaffoldBackgroundColor: const Color(0xFFFAF9F6),
    fontFamily: FontResoft.poppins,
    package: FontResoft.package,
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xff252525))),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffBD7879),
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
          color: Color(0xff394346),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xff394346),
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
    brightness: Brightness.light,
    iconTheme: const IconThemeData(color: Color(0xff394346)),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xffBD7879),
    ).copyWith(
      background: const Color(0xFFFAF9F6),
      secondary: const Color(0xff394346),
    ),
  );
}

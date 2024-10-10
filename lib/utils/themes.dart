/*
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
          color: Color(0xffB3BDC0) */
/*Color(0xff394346)*/ /*
,
          width: 2,
        ),
      ),
      labelStyle: TextStyle(color: Color(0xffBD7879)),
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

  /// DARK MODE

  final ThemeData darkThemeData = ThemeData(
    primaryColor: const Color(0xffBD7879),
    primaryColorDark: const Color(0xff394346),
    scaffoldBackgroundColor: const Color(0xFF141414),
    fontFamily: FontResoft.poppins,
    package: FontResoft.package,
    textTheme: const TextTheme(bodyMedium: TextStyle(color: const Color(0xffF5F5F5))),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff181B20), // Darker background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, // Whiter foreground color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xffB3BDC0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(
          color: Color(0xff394346), // Lighter border color
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xff394346), // Lighter border color
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
      color: const Color(0xff212121),
      surfaceTintColor: const Color(0xff212121),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xffB3BDC0), width: 1),
      ),
      elevation: 0,
    ),
    brightness: Brightness.light,
    iconTheme: const IconThemeData(color: Color(0xffB3BDC0)),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xffB3BDC0),
    ).copyWith(
      primary: const Color(0xffB3BDC0),
      primaryContainer: const Color(0xff465760),
      secondary: const Color(0xff794F50),
      tertiary: const Color(0xff687A80),
      surface: const Color(0xFF394346),
      surfaceTint: const Color(0xff465760),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF394346),
      selectedItemColor: Color(0xffB3BDC0),
      unselectedItemColor: Color(0xff687A80),
      selectedIconTheme: IconThemeData(
        color: Color(0xffB3BDC0),
      ),
      unselectedIconTheme: IconThemeData(
        color: Color(0xff687A80),
      ),
      selectedLabelStyle: TextStyle(color: Color(0xffB3BDC0)),
      unselectedLabelStyle: TextStyle(color: Color(0xff687A80)),
      showUnselectedLabels: true,
    ),
  );
}
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme/theme_cubit.dart';

class AppTheme {
  final BuildContext context;

  AppTheme(this.context);

  bool get isDarkMode {
    final themeMode = context.watch<ThemeCubit>().state;
    if (themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  ThemeData get themeData {
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;

    return ThemeData(
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness, // Ensure ColorScheme uses the same brightness
      ),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: textColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: buttonTextColor, // variable for button text color
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: secondaryColor,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        surfaceTintColor: surfaceTintColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: secondaryColor,
            width: 1,
          ),
        ),
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scaffoldBackgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryColor,
        selectedIconTheme: IconThemeData(
          color: primaryColor,
        ),
        unselectedIconTheme: IconThemeData(
          color: secondaryColor,
        ),
        selectedLabelStyle: TextStyle(
          color: primaryColor,
        ),
        unselectedLabelStyle: TextStyle(
          color: secondaryColor,
        ),
        showUnselectedLabels: true,
      ),
    );
  }

  // Add your color properties like primaryColor, scaffoldBackgroundColor, etc.
  Color get primaryColor => isDarkMode ? _darkPrimaryColor : _lightPrimaryColor;

  Color get scaffoldBackgroundColor => isDarkMode ? _darkScaffoldBackgroundColor : _lightScaffoldBackgroundColor;

  Color get textColor => isDarkMode ? _darkTextColor : _lightTextColor;

  Color get secondaryColor => isDarkMode ? _darkSecondaryColor : _lightSecondaryColor;

  Color get surfaceTintColor => isDarkMode ? _darkSurfaceTintColor : _lightSurfaceTintColor;

  Color get buttonTextColor => isDarkMode ? _darkButtonTextColor : _lightButtonTextColor; // New variable for button text

  Color get cardColor => isDarkMode ? _darkCardColor : _lightCardColor;

  // Define your colors here.
  static const Color _lightPrimaryColor = Color(0xff394346);
  static const Color _darkPrimaryColor = Color(0xffBD7879);
  static const Color _lightScaffoldBackgroundColor = Color(0xFFFAF9F6);
  static const Color _darkScaffoldBackgroundColor = Color(0xFF141414);
  static const Color _lightTextColor = Color(0xff394346);
  static const Color _darkTextColor = Color(0xffF5F5F5);
  static const Color _lightSecondaryColor = Color(0xffB3BDC0);
  static const Color _darkSecondaryColor = Color(0xff687A80);
  static const Color _lightSurfaceTintColor = Color(0xffF4F4F4);
  static const Color _darkSurfaceTintColor = Color(0xff465760);
  static const Color _lightButtonTextColor = Colors.white; // Define color for light theme button text
  static const Color _darkButtonTextColor = Colors.black; // Define color for dark theme button text
  static const Color _lightCardColor = Color(0xFFF5F5F5); // Define light card color
  static const Color _darkCardColor = Color(0xff212121); // Define dark card color
}

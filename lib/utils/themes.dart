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
          foregroundColor: buttonTextColor, // Use record for button text color
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

  // Define a record to hold light and dark colors for easy access
  final (Color light, Color dark) primaryColors = (Color(0xff394346), Color(0xffBD7879));
  final (Color light, Color dark) scaffoldBackgroundColors = (Color(0xFFFAF9F6), Color(0xFF141414));
  final (Color light, Color dark) textColors = (Color(0xff394346), Color(0xffF5F5F5));
  final (Color light, Color dark) secondaryColors = (Color(0xffB3BDC0), Color(0xff687A80));
  final (Color light, Color dark) surfaceTintColors = (Color(0xffF4F4F4), Color(0xff465760));
  final (Color light, Color dark) buttonTextColors = (Colors.white, Colors.black);
  final (Color light, Color dark) cardColors = (Color(0xFFF5F5F5), Color(0xff212121));

  // Use getters to access the correct color based on isDarkMode
  Color get primaryColor => isDarkMode ? primaryColors.$2 : primaryColors.$1;

  Color get scaffoldBackgroundColor => isDarkMode ? scaffoldBackgroundColors.$2 : scaffoldBackgroundColors.$1;

  Color get textColor => isDarkMode ? textColors.$2 : textColors.$1;

  Color get secondaryColor => isDarkMode ? secondaryColors.$2 : secondaryColors.$1;

  Color get surfaceTintColor => isDarkMode ? surfaceTintColors.$2 : surfaceTintColors.$1;

  Color get buttonTextColor => isDarkMode ? buttonTextColors.$2 : buttonTextColors.$1;

  Color get cardColor => isDarkMode ? cardColors.$2 : cardColors.$1;
}


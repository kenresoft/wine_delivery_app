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

  get border {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );
  }

  ColorScheme get colorScheme {
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    ).copyWith(
      primary: secondaryColor,
      primaryContainer: surfaceTintColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      surface: surfaceColor,
      surfaceTint: surfaceTintColor,
    );
  }

  ThemeData get themeData {

    return ThemeData(
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: textColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        // backgroundColor: Colors.transparent,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: border,
        selectedColor: colorScheme.secondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: buttonTextColor, // Use record for button text color
          backgroundColor: primaryColor,
          shape: border,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: border,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryColor,
          shape: border,
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
      tabBarTheme: TabBarTheme(
        labelColor: colorScheme.secondary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.secondary,
              width: 2,
            ),
          ),
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: colorScheme.surface,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedItemColor: colorScheme.onSurface,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: 0,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        showUnselectedLabels: true,
      ),
    );
  }

  // Define a record to hold light and dark colors for easy access
  static const seedColors = (
    rootColor,
    baseColor,
  );

  static const primaryColors = (
    Color(0xff394346),
    baseColor,
  );

  static const secondaryColors = (
    Color(0xffB3BDC0),
    Color(0xff687A80),
  );

  static const tertiaryColors = (
    Color(0xFFBD7879),
    Color(0xff794F50),
  );

  static const surfaceColors = (
    Color(0xFFF4F4F4),
    Color(0xFF394346),
  );

  static const surfaceTintColors = (
    Color(0xffF4F4F4),
    Color(0xff465760),
  );

  static const scaffoldBackgroundColors = (
    Color(0xFFFAF9F6),
    Color(0xFF141414),
  );

  static const textColors = (
    Color(0xff394346),
    Color(0xffF5F5F5),
  );

  static const buttonTextColors = (
    Colors.white,
    Colors.black,
  );

  static const cardColors = (
    Color(0xFFF5F5F5),
    Color(0xff212121),
  );

  // Use getters to access the correct color based on isDarkMode
  Color get seedColor => isDarkMode ? seedColors.$2 : seedColors.$1;

  Color get primaryColor => isDarkMode ? primaryColors.$2 : primaryColors.$1;

  Color get secondaryColor => isDarkMode ? secondaryColors.$2 : secondaryColors.$1;

  Color get tertiaryColor => isDarkMode ? tertiaryColors.$2 : tertiaryColors.$1;

  Color get surfaceColor => isDarkMode ? surfaceColors.$2 : surfaceColors.$1;

  Color get surfaceTintColor => isDarkMode ? surfaceTintColors.$2 : surfaceTintColors.$1;

  Color get scaffoldBackgroundColor => isDarkMode ? scaffoldBackgroundColors.$2 : scaffoldBackgroundColors.$1;

  Color get textColor => isDarkMode ? textColors.$2 : textColors.$1;

  Color get buttonTextColor => isDarkMode ? buttonTextColors.$2 : buttonTextColors.$1;

  Color get cardColor => isDarkMode ? cardColors.$2 : cardColors.$1;

  static const Color baseColor = Color(0xffBD7879);
  static const Color rootColor = Color(0xff7d557a);
}


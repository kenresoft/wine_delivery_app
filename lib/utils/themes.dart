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
      primary: primaryColor,
      primaryContainer: primaryContainerColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      surface: surfaceColor,
      surfaceTint: surfaceTintColor,
    );
  }

  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true, // Enable Material 3 theme features
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      fontFamily: 'Poppins',
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
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
          foregroundColor: colorScheme.tertiary,
          backgroundColor: primaryColor,
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
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: border,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: iconColor,
          backgroundColor: iconButtonBackgroundColor,
          shape: border,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.secondary,
            width: 2,
          ),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: border,
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
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: 0,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        showUnselectedLabels: true,
      ),
      chipTheme: chipTheme,
      iconTheme: IconThemeData(
        color: iconColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  TextTheme get textTheme {
    return TextTheme(
      bodyLarge: TextStyle(color: textColor, fontSize: 18),
      bodyMedium: TextStyle(color: textColor, fontSize: 16),
      bodySmall: TextStyle(color: textColor, fontSize: 14),
      headlineLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
      headlineMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
      headlineSmall: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
      titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 22),
      titleMedium: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 18),
      titleSmall: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 16),
      labelLarge: TextStyle(color: buttonTextColor, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  ChipThemeData get chipTheme {
    return ChipThemeData(
      backgroundColor: surfaceColor,
      selectedColor: primaryColor,
      disabledColor: colorScheme.onSurface.withOpacity(0.12),
      labelStyle: TextStyle(
        color: textColor,
      ),
      secondaryLabelStyle: TextStyle(
        color: buttonTextColor,
      ),
      padding: const EdgeInsets.all(8.0),
    );
  }

  // Define light and dark color schemes for Material 3 compliance
  static const seedColors = (
    // Color(0xffBD7879), // Light mode seed color
    Color(0xff7d557a), // Dark mode seed color
    Color(0xfff69202), // Light mode seed color
  );

  static const primaryColors = (
    Color(0xff394346), // Light mode primary
    Color(0xff212121), // Dark mode primary
  );

  static const secondaryColors = (
    Color(0xffB3BDC0), // Light mode secondary
    Color(0xff687A80), // Dark mode secondary
  );

  static const tertiaryColors = (
    Color(0xFFBD7879), // Light mode tertiary
    Color(0xff794F50), // Dark mode tertiary
  );

  static const surfaceColors = (
    Color(0xFFF4F4F4), // Light mode surface
    Color(0xFF394346), // Dark mode surface
  );

  static const surfaceTintColors = (
    Color(0xffF4F4F4), // Light mode surface tint
    Color(0xff465760), // Dark mode surface tint
  );

  static const scaffoldBackgroundColors = (
    Color(0xFFFAF9F6), // Light mode scaffold background
    Color(0xFF141414), // Dark mode scaffold background
  );

  static const textColors = (
    Color(0xff394346), // Light mode text
    Color(0xffF5F5F5), // Dark mode text
  );

  static const buttonTextColors = (
    Colors.white, // Light mode button text
    Colors.black, // Dark mode button text
  );

  static const iconColors = (
    Color(0xff394346), // Light mode icon color
    Color(0xffF5F5F5), // Dark mode icon color
  );

  static const iconButtonBackgroundColors = (
    Colors.transparent, // Light mode icon button background
    Colors.transparent, // Dark mode icon button background
  );

  static const cardColors = (
    Color(0xFFF5F5F5), // Light mode card
    Color(0xff212121), // Dark mode card
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

  Color get iconColor => isDarkMode ? iconColors.$2 : iconColors.$1;

  Color get iconButtonBackgroundColor => isDarkMode ? iconButtonBackgroundColors.$2 : iconButtonBackgroundColors.$1;

  Color get cardColor => isDarkMode ? cardColors.$2 : cardColors.$1;

  Color get primaryContainerColor => isDarkMode ? surfaceColors.$2 : surfaceColors.$1;
}

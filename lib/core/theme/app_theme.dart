import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/theme/app_button_theme.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_text_theme.dart';
import 'package:vintiora/core/theme/bloc/theme_bloc.dart';

ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;

ThemeData theme(BuildContext context) => Theme.of(context);

ThemeData lightTheme(BuildContext context) => AppTheme(context).lightTheme;

ThemeData darkTheme(BuildContext context) => AppTheme(context).darkTheme;

bool isDark(BuildContext context) => AppTheme(context).isDarkMode;

class AppTheme {
  final BuildContext context;

  AppTheme(this.context);

  bool get isDarkMode {
    final themeState = context.watch<ThemeBloc>().state;
    if (themeState.themeMode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    } else {
      return themeState.themeMode == ThemeMode.dark;
    }
  }

  /// Light theme configuration
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.lightElevatedText,
        secondary: AppColors.secondary,
        surface: theme(context).scaffoldBackgroundColor,
        onSurface: theme(context).textTheme.bodyLarge?.color ?? Colors.black,
      ),
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white4,
      secondaryHeaderColor: AppColors.secondary,
      brightness: Brightness.light,
      buttonTheme: const AppButtonTheme().buttonTheme,
      elevatedButtonTheme: const AppButtonTheme().lightElevatedButtonStyle,
      outlinedButtonTheme: const AppButtonTheme().lightOutlinedButtonStyle,
      indicatorColor: AppColors.lightIndicator,
      cardTheme: CardTheme(
        color: AppColors.white,
        surfaceTintColor: AppColors.grey1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.grey1, width: 1.5),
        ),
        elevation: 0,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.white,
        selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
        iconColor: AppColors.grey6,
        textColor: AppColors.lightTextTitle,
        titleTextStyle: const AppTextTheme().lightTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: const AppTextTheme().lightTextTheme.bodyMedium?.copyWith(
          color: AppColors.grey4,
        ),
        leadingAndTrailingTextStyle: const AppTextTheme().lightTextTheme.bodySmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.grey1, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        horizontalTitleGap: 16,
        minVerticalPadding: 12,
        minLeadingWidth: 24,
        style: ListTileStyle.list,
        dense: false,
        enableFeedback: true,
        selectedColor: AppColors.primary,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.grey1.withValues(alpha: 0.8),
        thickness: 1.0,
        indent: 16.0,
        endIndent: 16.0,
        space: 10.0,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.lightTextTitle),
        titleTextStyle: TextStyle(
          color: AppColors.lightTextTitle,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      fontFamily: 'SFProDisplay',
      textTheme: const AppTextTheme().lightTextTheme,
    );
  }

  /// Dark theme configuration
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.secondary,
      secondaryHeaderColor: AppColors.white,
      brightness: Brightness.dark,
      buttonTheme: const AppButtonTheme().buttonTheme,
      elevatedButtonTheme: const AppButtonTheme().darkElevatedButtonStyle,
      outlinedButtonTheme: const AppButtonTheme().darkOutlinedButtonStyle,
      indicatorColor: AppColors.darkIndicator,
      cardTheme: CardTheme(
        color: AppColors.grey8,
        surfaceTintColor: AppColors.grey7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.grey7, width: 0.5),
        ),
        elevation: 0,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.grey8,
        selectedTileColor: AppColors.primary.withValues(alpha: 0.2),
        iconColor: AppColors.grey2,
        textColor: AppColors.darkTextTitle,
        titleTextStyle: const AppTextTheme().darkTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: const AppTextTheme().darkTextTheme.bodyMedium?.copyWith(
          color: AppColors.grey3,
        ),
        leadingAndTrailingTextStyle: const AppTextTheme().darkTextTheme.bodySmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.grey6, width: 0.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        horizontalTitleGap: 16,
        minVerticalPadding: 12,
        minLeadingWidth: 24,
        style: ListTileStyle.list,
        dense: false,
        enableFeedback: true,
        selectedColor: AppColors.primary,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.grey6.withValues(alpha: 0.5),
        thickness: 1.0,
        indent: 16.0,
        endIndent: 16.0,
        space: 10.0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkTextTitle),
        titleTextStyle: TextStyle(
          color: AppColors.darkTextTitle,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      fontFamily: 'SFProDisplay',
      textTheme: const AppTextTheme().darkTextTheme,
    );
  }
}

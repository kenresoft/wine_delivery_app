import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextTheme {
  const AppTextTheme();

  TextTheme get lightTextTheme {
    return const TextTheme(
      // Display
      displayLarge: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 57.0,
        height: 1.12,
        letterSpacing: -0.25,
        color: AppColors.lightTextTitle,
      ),
      displayMedium: TextStyle(
        fontWeight: FontWeight.w700,
        // 45.0
        fontSize: 16.0,
        height: 1.16,
        letterSpacing: 0.0,
        color: AppColors.lightTextTitle,
      ),
      displaySmall: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 36.0,
        height: 1.22,
        letterSpacing: 0.0,
        color: AppColors.lightTextTitle,
      ),

      // Headline
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 32.0,
        height: 1.25,
        letterSpacing: 0.0,
        color: AppColors.lightText,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 28.0,
        height: 1.29,
        letterSpacing: 0.0,
        color: AppColors.lightText,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
        height: 1.33,
        letterSpacing: 0.0,
        color: AppColors.lightText,
      ),

      // Title
      titleLarge: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 22.0,
        height: 1.27,
        letterSpacing: 0.0,
        color: AppColors.secondary,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        height: 1.5,
        letterSpacing: 0.15,
        color: AppColors.lightText,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        height: 1.43,
        letterSpacing: 0.1,
        color: AppColors.lightText,
      ),

      // Body
      bodyLarge: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        height: 1.5,
        letterSpacing: 0.5,
        color: AppColors.lightText,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        height: 1.43,
        letterSpacing: 0.25,
        color: AppColors.lightText,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
        height: 1.33,
        letterSpacing: 0.4,
        color: AppColors.grey4,
      ),

      // Label
      labelLarge: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        height: 1.43,
        letterSpacing: 0.1,
        color: AppColors.lightText,
      ),
      labelMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
        height: 1.33,
        letterSpacing: 0.5,
        color: AppColors.lightText,
      ),
      labelSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 11.0,
        height: 1.45,
        letterSpacing: 0.5,
        color: AppColors.grey4,
      ),
    );
  }

  TextTheme get darkTextTheme {
    return const TextTheme(
      // Display
      displayLarge: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 57.0,
        height: 1.12,
        letterSpacing: -0.25,
        color: AppColors.darkTextTitle,
      ),
      displayMedium: TextStyle(
        fontWeight: FontWeight.w700,
        // 45.0
        fontSize: 16.0,
        height: 1.16,
        letterSpacing: 0.0,
        color: AppColors.darkTextTitle,
      ),
      displaySmall: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 36.0,
        height: 1.22,
        letterSpacing: 0.0,
        color: AppColors.darkTextTitle,
      ),

      // Headline
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 32.0,
        height: 1.25,
        letterSpacing: 0.0,
        color: AppColors.darkText,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 28.0,
        height: 1.29,
        letterSpacing: 0.0,
        color: AppColors.darkText,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
        height: 1.33,
        letterSpacing: 0.0,
        color: AppColors.darkText,
      ),

      // Title
      titleLarge: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 22.0,
        height: 1.27,
        letterSpacing: 0.0,
        color: AppColors.white,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        height: 1.5,
        letterSpacing: 0.15,
        color: AppColors.darkText,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        height: 1.43,
        letterSpacing: 0.1,
        color: AppColors.darkText,
      ),

      // Body
      bodyLarge: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        height: 1.5,
        letterSpacing: 0.5,
        color: AppColors.darkText,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        height: 1.43,
        letterSpacing: 0.25,
        color: AppColors.darkText,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
        height: 1.33,
        letterSpacing: 0.4,
        color: AppColors.grey3,
      ),

      // Label
      labelLarge: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        height: 1.43,
        letterSpacing: 0.1,
        color: AppColors.darkText,
      ),
      labelMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
        height: 1.33,
        letterSpacing: 0.5,
        color: AppColors.darkText,
      ),
      labelSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 11.0,
        height: 1.45,
        letterSpacing: 0.5,
        color: AppColors.grey3,
      ),
    );
  }
}

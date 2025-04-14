import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppButtonTheme {
  const AppButtonTheme();

  /// Custom button themes matching the design
  ButtonThemeData get buttonTheme {
    return ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  /// Primary -> Elevated
  ElevatedButtonThemeData get lightElevatedButtonStyle {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.lightElevatedText,
        backgroundColor: AppColors.lightElevatedBg,
        disabledForegroundColor: AppColors.white5,
        disabledBackgroundColor: AppColors.white4,
        iconColor: AppColors.lightElevatedIcon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
        elevation: 0,
      ),
    );
  }

  ElevatedButtonThemeData get darkElevatedButtonStyle {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.darkElevatedText,
        backgroundColor: AppColors.darkElevatedBg,
        disabledForegroundColor: AppColors.grey5,
        disabledBackgroundColor: AppColors.grey8,
        iconColor: AppColors.darkElevatedIcon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
        elevation: 0,
      ),
    );
  }

  /// __Note:__ Input [height] is responsive
  static ButtonStyle elevatedButton(double height) {
    return ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, height.h.clamp(height, 63)),
      padding: EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        fontFamily: 'SFProDisplay',
      ),
    );
  }

  static ButtonStyle get defaultElevatedButton {
    return ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 51.h.clamp(56, 63)),
      padding: EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        fontFamily: 'SFProDisplay',
      ),
    );
  }

  static ButtonStyle get actionButton {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary.withValues(alpha: 0.5),
      shadowColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: BorderSide(color: AppColors.primary, width: 0.5),
      minimumSize: Size(double.infinity, 51.h.clamp(56, 63)),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: 'SFProDisplay',
      ),
    );
  }

  /// Secondary -> Outlined
  OutlinedButtonThemeData get lightOutlinedButtonStyle {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightOutlinedText,
        disabledForegroundColor: AppColors.lightOutlinedText.withValues(alpha: 0.5),
        backgroundColor: AppColors.lightOutlinedBg,
        iconColor: AppColors.lightOutlinedIcon,
        side: const BorderSide(color: AppColors.lightOutlinedBorder, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
      ),
    );
  }

  OutlinedButtonThemeData get darkOutlinedButtonStyle {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkOutlinedText,
        disabledForegroundColor: AppColors.darkOutlinedText.withValues(alpha: 0.5),
        side: const BorderSide(color: AppColors.darkOutlinedBorder, width: 1),
        backgroundColor: AppColors.darkOutlinedBg,
        iconColor: AppColors.darkOutlinedIcon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
      ),
    );
  }

  static ButtonStyle get outlinedButton {
    return OutlinedButton.styleFrom(
      minimumSize: Size(double.infinity, 51.h.clamp(56, 63)),
      padding: EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        fontFamily: 'SFProDisplay',
      ),
    );
  }

  static ButtonStyle get activeSelectableButton {
    return OutlinedButton.styleFrom(
      minimumSize: Size(120.w, 40.h.clamp(40, 50)),
      padding: EdgeInsets.all(8),
      side: const BorderSide(color: AppColors.primary, width: 1.5),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        fontFamily: 'SFProDisplay',
      ),
    );
  }

  static ButtonStyle get inActiveSelectableButton {
    return OutlinedButton.styleFrom(
      minimumSize: Size(120.w, 40.h.clamp(40, 50)),
      padding: EdgeInsets.all(8),
      side: const BorderSide(color: AppColors.lightOutlinedBorder, width: 0.5),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontFamily: 'SFProDisplay',
      ),
    );
  }

  static ButtonStyle get counterButton {
    return OutlinedButton.styleFrom(
      minimumSize: Size(51.w, 51.h.clamp(51, 61)),
      padding: EdgeInsets.all(8),
      side: const BorderSide(color: AppColors.lightOutlinedBorder, width: 0.6),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontFamily: 'SFProDisplay',
      ),
    );
  }

  static ButtonStyle get outlinedErrorButton {
    return OutlinedButton.styleFrom(
      minimumSize: Size(double.infinity, 51.h.clamp(56, 63)),
      padding: EdgeInsets.symmetric(vertical: 16),
      foregroundColor: AppColors.error,
      side: const BorderSide(color: AppColors.error, width: 1),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        fontFamily: 'SFProDisplay',
      ),
    );
  }
}

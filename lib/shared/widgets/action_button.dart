import 'package:flutter/material.dart';
import 'package:vintiora/core/theme/app_button_theme.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/shared/components/svg_wrapper.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.asset,
  });

  final GestureTapCallback onPressed;
  final String label;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: AppButtonTheme.actionButton,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: isDark(context) ? AppColors.white : AppColors.secondary),
              ),
            ),
            if (asset != null)
              Positioned(
                left: 0,
                child: SvgWrapper(
                  asset!,
                  width: 18,
                  height: 18,
                  color: isDark(context) ? AppColors.white : AppColors.secondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

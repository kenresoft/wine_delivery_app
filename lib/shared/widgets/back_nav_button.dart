import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/utils/asset_handler.dart';
import 'package:vintiora/shared/components/svg_wrapper.dart';

class BackNavButton extends StatelessWidget {
  final GestureTapCallback? onPressed;

  const BackNavButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final navColor = theme(context).outlinedButtonTheme.style!.iconColor!.resolve({WidgetState.focused})!;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40.r,
        height: 40.r,
        margin: const EdgeInsets.only(bottom: 32).r,
        padding: const EdgeInsets.all(8).r,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: navColor,
            ),
            borderRadius: BorderRadius.circular(8).r,
          ),
        ),
        child: SvgWrapper(
          Assets.arrowBackward,
          height: 24.r,
          width: 24.r,
          color: navColor,
        ),
      ),
    );
  }
}

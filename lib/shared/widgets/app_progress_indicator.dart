import 'package:flutter/material.dart';
import 'package:vintiora/core/theme/app_colors.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: AppColors.grey2,
        strokeWidth: 2,
        strokeAlign: 8,
      ),
    );
  }
}

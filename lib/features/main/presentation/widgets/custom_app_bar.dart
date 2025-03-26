import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintiora/core/di/di_setup.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/utils/asset_handler.dart';
import 'package:vintiora/features/main/presentation/bloc/navigation/bottom_navigation_bloc.dart';
import 'package:vintiora/shared/components/svg_wrapper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Primary configuration parameters
  final String title;
  final TextStyle? titleStyle;
  final bool showLeading;
  final GestureTapCallback? onBackPressed;

  /// Action configuration parameters
  final String? action;
  final GestureTapCallback? onActionPressed;
  final Color? actionSelectedColor;
  final int? counter;

  /// Enhanced configuration parameters
  final bool centerTitle;
  final double? toolbarHeight;
  final Color? backgroundColor;
  final double elevation;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.titleStyle,
    this.showLeading = true,
    this.onBackPressed,
    this.action,
    this.onActionPressed,
    this.actionSelectedColor,
    this.counter,
    this.centerTitle = true,
    this.toolbarHeight,
    this.backgroundColor,
    this.elevation = 0,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = isDark(context);
    final Color iconColor = isDarkMode ? Colors.white : AppColors.secondary;
    final EdgeInsets buttonPadding = EdgeInsets.all(8);
    final EdgeInsets buttonMargin = EdgeInsets.symmetric(horizontal: 8).copyWith(left: 0);

    return AppBar(
      elevation: elevation,
      title: _buildTitleStack(context, iconColor, buttonMargin, buttonPadding),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      toolbarHeight: (toolbarHeight ?? 48).h,
      // leading: leading ?? _buildLeading(context, iconColor),
      actions: [
        if (action != null) _buildActionIcon(context, iconColor),
        ...?actions,
      ],
    );
  }

  /// Optimized title stack builder
  Widget _buildTitleStack(BuildContext context, Color iconColor, EdgeInsets buttonMargin, EdgeInsets buttonPadding) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLeading(context, iconColor),
            Row(
              children: [
                SizedBox(width: 5),
                Text(
                  title,
                  style: titleStyle ??
                      theme(context).textTheme.titleMedium?.copyWith(
                            color: iconColor,
                          ),
                ),
              ],
            ),

            // Placeholder for symmetry when no action exists
            if ((action == null && (actions == null || actions!.isEmpty)))
              Container(
                margin: buttonMargin,
                padding: buttonPadding,
                height: 40,
                width: 40,
              )
            else
              SizedBox(),
          ],
        ),
      ],
    );
  }

  /// Intelligent leading button builder
  Widget _buildLeading(BuildContext context, Color iconColor) {
    return showLeading
        ? GestureDetector(
            onTap: onBackPressed ?? () => _handleBackPress(context),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8).copyWith(left: 0),
              padding: EdgeInsets.all(8),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grey2),
              ),
              child: SvgWrapper(
                Assets.arrowBackward,
                color: iconColor,
              ),
            ),
          )
        : SizedBox();
  }

  /// Flexible action icon builder
  Widget _buildActionIcon(BuildContext context, Color iconColor) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: onActionPressed,
            child: SizedBox(
              height: 24,
              width: 24,
              child: SvgWrapper(
                action!,
                color: actionSelectedColor ?? iconColor,
              ),
            ),
          ),
          if (counter != null)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(32),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$counter',
                  style: theme(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleBackPress(BuildContext context) {
    getIt<NavigationBloc>().add(const PageTapped(0));
    // Nav.pop();
  }

  @override
  Size get preferredSize => Size.fromHeight((toolbarHeight ?? 48).h);
}

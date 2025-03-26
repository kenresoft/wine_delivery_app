import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintiora/core/di/di_setup.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/utils/asset_handler.dart';
import 'package:vintiora/features/main/presentation/bloc/navigation/bottom_navigation_bloc.dart';
import 'package:vintiora/shared/components/svg_wrapper.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final bool showLeading;
  final GestureTapCallback? onBackPressed;
  final String? action;
  final GestureTapCallback? onActionPressed;
  final Color? actionSelectedColor;
  final int? counter;

  // New configuration parameters
  final bool pinned;
  final bool floating;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final double toolbarHeight;

  const CustomSliverAppBar({
    super.key,
    this.title = '',
    this.titleStyle,
    this.showLeading = true,
    this.onBackPressed,
    this.action,
    this.onActionPressed,
    this.actionSelectedColor,
    this.counter,
    this.pinned = true,
    this.floating = false,
    this.expandedHeight,
    this.flexibleSpace,
    this.bottom,
    this.centerTitle = true,
    this.toolbarHeight = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = isDark(context);
    final Color iconColor = isDarkMode ? Colors.white : AppColors.secondary;
    final EdgeInsets buttonPadding = EdgeInsets.all(8);
    final EdgeInsets buttonMargin = EdgeInsets.symmetric(horizontal: 8).copyWith(left: 0);

    return SliverAppBar(
      elevation: 0,
      pinned: pinned,
      floating: floating,
      snap: false,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace ?? _buildDefaultFlexibleSpace(context),
      bottom: bottom,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              showLeading
                  ? GestureDetector(
                      onTap: onBackPressed ?? () => _handleBackPress(context),
                      child: Container(
                        margin: buttonMargin,
                        padding: buttonPadding,
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
                  : const SizedBox(),
              Text(
                title,
                style: titleStyle ??
                    theme(context).textTheme.titleMedium?.copyWith(
                          color: iconColor,
                        ),
              ),
              Container(
                margin: buttonMargin,
                padding: buttonPadding,
                height: 40,
                width: 40,
              ),
            ],
          ),
          if (action != null)
            Positioned(
              right: 8,
              child: SizedBox(
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
              ),
            ),
        ],
      ),
      centerTitle: centerTitle,
      backgroundColor: theme(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      toolbarHeight: toolbarHeight.h,
    );
  }

  Widget? _buildDefaultFlexibleSpace(BuildContext context) {
    // A default flexible space if not specified
    return flexibleSpace ??
        (expandedHeight != null
            ? FlexibleSpaceBar(
                title: Text(
                  title,
                  style: titleStyle ?? theme(context).textTheme.titleMedium,
                ),
                centerTitle: centerTitle,
              )
            : null);
  }

  void _handleBackPress(BuildContext context) {
    getIt<NavigationBloc>().add(const PageTapped(0));
  }
}

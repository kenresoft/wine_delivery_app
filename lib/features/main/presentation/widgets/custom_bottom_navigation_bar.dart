import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/utils/asset_handler.dart';
import 'package:vintiora/shared/components/svg_wrapper.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(top: 6, bottom: 8),
        decoration: BoxDecoration(
          color: isDark(context) ? AppColors.secondary : AppColors.white,
          borderRadius: BorderRadius.circular(60),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
            BoxShadow(
              color: (isDark(context) ? AppColors.white : AppColors.black).withValues(alpha: 0.1),
              blurRadius: 8.r,
              offset: Offset(0, -2.r),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _buildNavItem(
                context,
                index: 0,
                icon: Assets.home,
                label: 'Home',
              ),
            ),
            Flexible(
              child: _buildNavItem(
                context,
                index: 1,
                icon: Assets.cart,
                label: 'Cart',
              ),
            ),
            Flexible(
              child: _buildNavItem(
                context,
                index: 2,
                icon: Assets.wishlist,
                label: 'Wishlist',
              ),
            ),
            Flexible(
              child: _buildNavItem(
                context,
                index: 3,
                icon: Assets.chat,
                label: 'Chat',
              ),
            ),
            Flexible(
              child: _buildNavItem(
                context,
                index: 4,
                icon: Assets.profile,
                label: 'Profile',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required int index, required String icon, required String label}) {
    final isSelected = currentIndex == index;
    final selectedColor = isDark(context) ? AppColors.secondary : Colors.white;
    final unSelectedColor = isDark(context) ? AppColors.grey3 : AppColors.grey4;
    return GestureDetector(
      onTap: () => onTap(index),
      child: SizedBox(
        height: 70,
        width: 54,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 22,
              child: Container(
                width: 32,
                height: 32,
                padding: const EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 8),
                SvgWrapper(
                  icon,
                  height: 18,
                  width: 18,
                  color: isSelected ? selectedColor : unSelectedColor,
                ),
                const Flexible(child: SizedBox(height: 10)),
                Text(
                  label,
                  maxLines: 1,
                  style: theme(context).textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : isDark(context)
                                ? AppColors.grey3
                                : AppColors.grey4,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintiora/core/config/app_config.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/utils/asset_handler.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/core/utils/extensions.dart';
import 'package:vintiora/features/category/domain/enums/wine_category.dart';
import 'package:vintiora/features/flash_sale/presentation/blocs/active_flash_sales/active_flash_sales_bloc.dart';
import 'package:vintiora/features/flash_sale/presentation/pages/flash_sale_details_page.dart';
import 'package:vintiora/features/flash_sale/presentation/widgets/flash_sale_banner.dart';
import 'package:vintiora/features/home/presentation/widgets/product_filter_section.dart';
import 'package:vintiora/features/promotion/presentation/widgets/promotion_banner_widget.dart';
import 'package:vintiora/features/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:vintiora/shared/components/app_wrapper.dart';
import 'package:vintiora/shared/components/svg_wrapper.dart';
import 'package:vintiora/shared/widgets/custom_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final double _categoryItemHeight = 85.0;
  final double _categoryIconSize = 60.0;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  bool _showAllCategories = false;
  final allCategories = WineCategory.values;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCategories() {
    setState(() {
      _showAllCategories = !_showAllCategories;
      if (_showAllCategories) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> _handleRefresh() async {
    try {
      return await Config.loadMainEvents(context).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Connection timed out'),
      );
    } catch (e) {
      if (!mounted) return;

      Nav.showCustomSnackBar(
        SnackBar(
          content: Text('Failed to refresh: ${e.toString().split('\n')[0]}'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _refreshKey.currentState?.show(),
          ),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = 24.0 * 2;
    final spacing = 16.0;
    final itemWidth = (1.sw - padding - (3 * spacing)) / 4;

    return AppWrapper(
      useSafeArea: true,
      child: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _handleRefresh,
        displacement: 40.0,
        color: const Color(0xFFCDA752),
        backgroundColor: isDark(context) ? AppColors.grey8 : Colors.white,
        strokeWidth: 2.5,
        edgeOffset: 16.0,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  children: [
                    // Location
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFCDA752),
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.black1,
                                        fontSize: 12,
                                      ),
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'New York, USA',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme(context).textTheme.headlineMedium?.copyWith(
                                              fontSize: 14,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 16,
                                      color: AppColors.black1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Profile
                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        final profileImage = state.profile?.profileImage ?? '';
                        return Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: AppCircleImage(
                            Constants.baseUrl + profileImage,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 45),
                        child: CustomTextField(
                          hintText: 'Search',
                          borderRadius: BorderRadius.circular(50),
                          prefixIcon: const SvgWrapper(Assets.search),
                          hintStyle: const TextStyle(),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCDA752),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: SvgWrapper(
                          Assets.filter,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Banner
            SliverToBoxAdapter(
              child: const PromotionBannerWidget(),
            ),

            // Category Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Category',
                      style: theme(context).textTheme.displayLarge?.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    TextButton(
                      onPressed: _toggleCategories,
                      child: Text(
                        _showAllCategories ? 'See Few' : 'See All',
                        style: theme(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Animated Category Layout
            SliverToBoxAdapter(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return _showAllCategories ? _buildCategoryGrid(itemWidth, spacing) : _buildCategoryRow(itemWidth, spacing);
                    },
                  ),
                ),
              ),
            ),
            // Flash Sale Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: BlocBuilder<ActiveFlashSalesBloc, ActiveFlashSalesState>(
                  builder: (context, state) {
                    if (state.status == ActiveFlashSalesStatus.loading) {
                      return const SizedBox(
                        height: 214,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state.status == ActiveFlashSalesStatus.error) {
                      return SizedBox(
                        height: 214,
                        child: Center(
                          child: Text(state.errorMessage, textAlign: TextAlign.center),
                        ),
                      );
                    }

                    if (state.flashSales.isEmpty) {
                      return const SizedBox(height: 214);
                    }

                    final flashSales = state.flashSales;

                    return SizedBox(
                      height: 214, // 218
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: flashSales.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final flashSale = flashSales[index];
                          return FlashSaleBanner(
                            flashSale: flashSale,
                            onViewAllTap: () {
                              Navigator.push(
                                // TODO: Use Nav
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlashSaleDetailsPage(
                                    flashSaleId: flashSale.id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // Filter Section
            const SliverToBoxAdapter(child: ProductFilterSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(double itemWidth, double spacing) {
    final displayedCategories = allCategories.take(4).toList();
    return SizedBox(
      height: _categoryItemHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayedCategories.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing),
        itemBuilder: (_, index) => _buildCategoryItem(displayedCategories[index], itemWidth),
      ),
    );
  }

  Widget _buildCategoryGrid(double itemWidth, double spacing) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: itemWidth / _categoryItemHeight,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      padding: EdgeInsets.zero,
      children: allCategories.map((cat) => _buildCategoryItem(cat, itemWidth)).toList(),
    );
  }

  Widget _buildCategoryItem(WineCategory category, double width) {
    return SizedBox(
      width: width,
      height: _categoryItemHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _categoryIconSize,
            height: _categoryIconSize,
            decoration: BoxDecoration(
              color: isDark(context) ? AppColors.grey8 : AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: isDark(context) ? AppColors.grey7 : AppColors.grey1),
            ),
            child: Icon(
              category.icon,
              color: const Color(0xFFCDA752),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme(context).textTheme.labelMedium?.copyWith(
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}

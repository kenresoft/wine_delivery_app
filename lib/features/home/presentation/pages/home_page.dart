import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/utils/asset_handler.dart';
import 'package:vintiora/core/utils/extensions.dart';
import 'package:vintiora/features/category/domain/enums/wine_category.dart';
import 'package:vintiora/features/flash_sale/presentation/blocs/active_flash_sales/active_flash_sales_bloc.dart';
import 'package:vintiora/features/flash_sale/presentation/pages/flash_sale_details_page.dart';
import 'package:vintiora/features/flash_sale/presentation/widgets/flash_sale_banner.dart';
import 'package:vintiora/features/home/presentation/widgets/product_filter_section.dart';
import 'package:vintiora/shared/components/app_wrapper.dart';
import 'package:vintiora/shared/components/svg_wrapper.dart';
import 'package:vintiora/shared/widgets/custom_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final categories = WineCategory.values.take(4).toList();

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      useSafeArea: true,
      child: CustomScrollView(
        slivers: [
          // App Bar
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
                              const Text(
                                'Location',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: const Text(
                                      'New York, USA',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: Colors.black.withValues(alpha: 0.7),
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
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: const AppCircleImage(
                      Assets.profilePicture,
                    ),
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
                      constraints: BoxConstraints(maxHeight: 45),
                      child: CustomTextField(
                        hintText: 'Search',
                        fillColor: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50),
                        prefixIcon: SvgWrapper(Assets.search),
                        hintStyle: TextStyle(),
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
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                height: 145,
                decoration: BoxDecoration(
                  color: AppColors.white3,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'New Collection',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Discount 50% for the first transaction',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFCDA752),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  minimumSize: const Size(100, 34),
                                ),
                                child: const Text(
                                  'Shop Now',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: AppImage(
                          "assets/images/wine-3.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Category Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Category Icons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                height: 95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(categories.length, (index) {
                    final category = categories[index];
                    return CategoryItem(
                      icon: category.icon,
                      label: category.name,
                    );
                  }),
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
          SliverToBoxAdapter(child: ProductFilterSection()),
        ],
      ),
    );
  }
}

// Category Item Widget
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.grey1),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFCDA752),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Bottom Navigation Bar Item
class NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final String label;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFCDA752) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/features/home/presentation/widgets/product_card.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/presentation/bloc/product/product_bloc.dart';

enum ProductFilterType { all, newest, popular }

class ProductFilterSection extends StatefulWidget {
  const ProductFilterSection({super.key});

  @override
  State<ProductFilterSection> createState() => _ProductFilterSectionState();
}

class _ProductFilterSectionState extends State<ProductFilterSection> {
  final ValueNotifier<ProductFilterType> _filterNotifier = ValueNotifier(ProductFilterType.all);

  @override
  void dispose() {
    _filterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: ValueListenableBuilder<ProductFilterType>(
            valueListenable: _filterNotifier,
            builder: (context, selectedFilter, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  EnhancedFilterChip(
                    label: 'All',
                    isSelected: selectedFilter == ProductFilterType.all,
                    onTap: () => _updateFilter(ProductFilterType.all),
                  ),
                  const SizedBox(width: 16),
                  EnhancedFilterChip(
                    label: 'Newest',
                    isSelected: selectedFilter == ProductFilterType.newest,
                    onTap: () => _updateFilter(ProductFilterType.newest),
                  ),
                  const SizedBox(width: 16),
                  EnhancedFilterChip(
                    label: 'Popular',
                    isSelected: selectedFilter == ProductFilterType.popular,
                    onTap: () => _updateFilter(ProductFilterType.popular),
                  ),
                ],
              );
            },
          ),
        ),

        // Filtered product grid
        ValueListenableBuilder<ProductFilterType>(
          valueListenable: _filterNotifier,
          builder: (context, selectedFilter, _) {
            return BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                final selectedProducts = _getFilteredProducts(state, selectedFilter);
                final isLoading = state.status == ProductsStatus.loading;
                final hasError = state.status == ProductsStatus.error;

                if (isLoading) {
                  return const SizedBox(
                    height: 214,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (hasError) {
                  return SizedBox(
                    height: 214,
                    child: Center(
                      child: Text(
                        state.errorMessage.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                // Show empty state if we have no products (after loading)
                if (selectedProducts == null || selectedProducts.isEmpty) {
                  return const SizedBox(
                    height: 214,
                    child: Center(
                      child: Text(
                        "No products available",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: (1.sw / 2 - 16) / 185.h.clamp(185, 310),
                    ),
                    itemCount: selectedProducts.length,
                    itemBuilder: (context, index) {
                      final product = selectedProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _updateFilter(ProductFilterType filter) {
    if (_filterNotifier.value != filter) {
      _filterNotifier.value = filter;
    }
  }

  List<Product>? _getFilteredProducts(ProductState state, ProductFilterType filter) {
    return switch (filter) {
      ProductFilterType.newest => state.newArrivals,
      ProductFilterType.popular => state.popularProducts,
      ProductFilterType.all => state.products,
    };
  }
}

class EnhancedFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const EnhancedFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: 32,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isSelected ? null : Border.all(color: Colors.grey.shade300),
          ),
          child: Material(
            color: isSelected ? const Color(0xFFCDA752) : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    label,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

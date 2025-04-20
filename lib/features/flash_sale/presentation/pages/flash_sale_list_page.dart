import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/router/routes.dart';
import 'package:vintiora/features/main/presentation/widgets/custom_app_bar.dart';
import 'package:vintiora/shared/components/app_wrapper.dart';
import 'package:vintiora/shared/widgets/animated_fade_scale.dart';

import '../blocs/active_flash_sales/active_flash_sales_bloc.dart';
import '../blocs/flash_sale_products/flash_sale_products_bloc.dart';
import '../widgets/flash_sale_banner.dart';
import '../widgets/flash_sale_product_card.dart';

class FlashSaleListPage extends StatelessWidget {
  const FlashSaleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      appBar: CustomAppBar(title: 'Flash Sales'),
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ActiveFlashSalesBloc>().add(RefreshActiveFlashSales());
          context.read<FlashSaleProductsBloc>().add(RefreshFlashSaleProducts());
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            // Flash Sale Banners section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, bottom: 8),
                child: Text(
                  'Active Flash Sales',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            BlocBuilder<ActiveFlashSalesBloc, ActiveFlashSalesState>(
              builder: (context, state) {
                if (state.status == ActiveFlashSalesStatus.loading) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                if (state.status == ActiveFlashSalesStatus.error) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Error: ${state.errorMessage}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ActiveFlashSalesBloc>().add(LoadActiveFlashSales());
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final flashSales = state.flashSales;

                if (flashSales.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No active flash sales right now.'),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final flashSale = flashSales[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 214,
                          child: FlashSaleBanner(
                            flashSale: flashSale,
                            onViewAllTap: () => Nav.push(
                              Routes.flashSaleDetails,
                              arguments: flashSale.id,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: flashSales.length,
                  ),
                );
              },
            ),

            // Flash Sale Products section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Flash Sale Products',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all flash sale products
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<FlashSaleProductsBloc, FlashSaleProductsState>(
              builder: (context, state) {
                // Trigger loading if initial state
                if (state.status == FlashSaleProductsStatus.initial) {
                  context.read<FlashSaleProductsBloc>().add(LoadFlashSaleProducts());
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (state.status == FlashSaleProductsStatus.loading) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (state.status == FlashSaleProductsStatus.error) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${state.errorMessage}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<FlashSaleProductsBloc>().add(LoadFlashSaleProducts());
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Handle refreshing state - show current products while loading
                if (state.status == FlashSaleProductsStatus.refreshing) {
                  if (state.products.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 320,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final flashSaleProduct = state.products[index];
                          return AnimatedFadeScale(
                            delay: Duration(milliseconds: 50 * index),
                            child: FlashSaleProductCard(
                              flashSaleProduct: flashSaleProduct,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }

                // Loaded state
                if (state.products.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No flash sale products available.'),
                      ),
                    ),
                  );
                }

                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 320,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return AnimatedFadeScale(
                          delay: Duration(milliseconds: 50 * index),
                          child: FlashSaleProductCard(
                            flashSaleProduct: product,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }
}

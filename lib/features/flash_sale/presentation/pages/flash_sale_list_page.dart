import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/active_flash_sales/active_flash_sales_bloc.dart';
import '../blocs/flash_sale_products/flash_sale_products_bloc.dart';
import '../widgets/flash_sale_banner.dart';
import '../widgets/flash_sale_product_card.dart';
import 'flash_sale_details_page.dart';

class FlashSaleListPage extends StatelessWidget {
  const FlashSaleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash Sales'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ActiveFlashSalesBloc>().add(RefreshActiveFlashSales());
          context.read<FlashSaleProductsBloc>().add(RefreshFlashSaleProducts());
          // Wait for the refresh to complete
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
            SliverToBoxAdapter(
              child: BlocBuilder<ActiveFlashSalesBloc, ActiveFlashSalesState>(
                builder: (context, state) {
                  if (state.status == ActiveFlashSalesStatus.loading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state.status == ActiveFlashSalesStatus.error) {
                    return Center(
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
                    );
                  }

                  final flashSales = state.flashSales;

                  if (flashSales.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No active flash sales right now.'),
                      ),
                    );
                  }

                  return Column(
                    children: flashSales
                        .map(
                          (flashSale) => FlashSaleBanner(
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
                          ),
                        )
                        .toList(),
                  );
                },
              ),
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
            SliverToBoxAdapter(
              child: BlocBuilder<ActiveFlashSalesBloc, ActiveFlashSalesState>(
                builder: (context, state) {
                  if (state.status == ActiveFlashSalesStatus.loading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state.status == ActiveFlashSalesStatus.error) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Error: ${state.errorMessage}'),
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
                    );
                  }
                  final products = state.flashSales;

                  if (products.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No flash sale products available.'),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 280,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return FlashSaleProductCard(
                          flashSale: product,
                          onTap: () {
                            // Navigate to product details
                          },
                        );
                      },
                    ),
                  );
                },
              ),
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

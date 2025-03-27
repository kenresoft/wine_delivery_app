import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/flash_sale/domain/entities/flash_sale.dart';
import 'package:vintiora/features/flash_sale/presentation/widgets/flash_sale_countdown_timer.dart';
import 'package:vintiora/features/main/presentation/widgets/custom_app_bar.dart';
import 'package:vintiora/features/main/presentation/widgets/custom_sliver_app_bar.dart';
import 'package:vintiora/shared/components/app_wrapper.dart';
import 'package:vintiora/shared/components/error_page.dart';

import '../blocs/flash_sale_details/flash_sale_details_bloc.dart';

class FlashSaleDetailsPage extends StatefulWidget {
  final String flashSaleId;

  const FlashSaleDetailsPage({
    super.key,
    required this.flashSaleId,
  });

  @override
  State<FlashSaleDetailsPage> createState() => _FlashSaleDetailsPageState();
}

class _FlashSaleDetailsPageState extends State<FlashSaleDetailsPage> {
  late ScrollController _scrollController;
  bool _isAppBarExpanded = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScrollChanged);

    // Trigger initial data load
    context.read<FlashSaleDetailsBloc>().add(LoadFlashSaleDetails(widget.flashSaleId));
  }

  void _onScrollChanged() {
    // Detect AppBar expansion state for dynamic title
    bool shouldBeExpanded = _scrollController.hasClients && _scrollController.offset > (200 - kToolbarHeight);

    if (shouldBeExpanded != _isAppBarExpanded) {
      setState(() {
        _isAppBarExpanded = shouldBeExpanded;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      child: BlocBuilder<FlashSaleDetailsBloc, FlashSaleDetailsState>(
        builder: (context, state) {
          // Handle different states with refined UI
          switch (state.status) {
            case FlashSaleDetailsStatus.loading:
              return _buildLoadingState();
            case FlashSaleDetailsStatus.error:
              return _buildErrorState(state.errorMessage);
            case FlashSaleDetailsStatus.loaded:
              return _buildLoadedState(state.flashSale!);
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Loading Flash Sale',
      ),
      body: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              height: 200,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Container(
              height: 100,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return ErrorPage(
      message: errorMessage,
      onRetry: () {
        context.read<FlashSaleDetailsBloc>().add(LoadFlashSaleDetails(widget.flashSaleId));
        return Future.value();
      },
      errorType: ErrorType.network,
    );
  }

  Widget _buildLoadedState(FlashSale flashSale) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Dynamic AppBar with scroll-based title
        CustomSliverAppBar(
          expandedHeight: 250,
          pinned: true,
          onBackPressed: () {
            Nav.pop();
          },
          title: _isAppBarExpanded ? flashSale.title : '',
          flexibleSpace: FlexibleSpaceBar(
            background: _buildHeaderSection(flashSale),
          ),
        ),

        // Flash Sale Details Section
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildFlashSaleDetailsCard(flashSale),
              const SizedBox(height: 16),
              _buildFlashSaleProductsList(flashSale),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(FlashSale flashSale) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.red.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.3,
            child: AppImage(
              '${Constants.baseUrl}/assets/images/vintiora-wine.png',
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flashSale.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  flashSale.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSaleDetailsCard(FlashSale flashSale) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sale Ends In:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                FlashSaleCountdownTimer(
                  hours: flashSale.timeRemainingFormatted.hours,
                  minutes: flashSale.timeRemainingFormatted.minutes,
                  seconds: flashSale.timeRemainingFormatted.seconds,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSaleProgressIndicator(flashSale),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleProgressIndicator(FlashSale flashSale) {
    double progressValue = flashSale.soldCount / flashSale.totalStock;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Discount: ${flashSale.discountPercentage}% OFF',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              'Stock: ${flashSale.stockRemaining}/${flashSale.totalStock}',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        Text(
          'Max ${flashSale.maxPurchaseQuantity} per order',
          style: TextStyle(
            // color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            // fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progressValue,
          backgroundColor: Colors.red.shade100,
          color: Colors.red.shade500,
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        Text(
          'Hurry! Only ${flashSale.stockRemaining} items left at this price.',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFlashSaleProductsList(FlashSale flashSale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flash Sale Products ${flashSale.maxPurchaseQuantity}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: flashSale.flashSaleProducts.multiply(times: 3).length,
          itemBuilder: (context, index) {
            final product = flashSale.flashSaleProducts.multiply(times: 3)[index];
            return _buildProductListItem(product);
          },
        ),
      ],
    );
  }

  Widget _buildProductListItem(FlashSaleProduct flashSale) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: AppImage(
            '${Constants.baseUrl}${flashSale.product.image}',
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          flashSale.product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Original Price: \$${flashSale.product.defaultPrice.toStringAsFixed(2)}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 14),
            ),
            Text(
              'Sale Price: \$${flashSale.specialPrice.toStringAsFixed(2)}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        horizontalTitleGap: 6,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        trailing: TextButton(
          onPressed: () {
            // TODO: Implement add to cart functionality
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red.shade500,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add to Cart'),
        ),
      ),
    );
  }
}

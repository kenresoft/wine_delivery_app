import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/router/routes.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/core/utils/date_formatter.dart';
import 'package:vintiora/core/utils/extensions.dart';
import 'package:vintiora/features/cart/presentation/bloc/cart/cart_bloc.dart';
import 'package:vintiora/features/main/presentation/widgets/custom_app_bar.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/domain/entities/product_pricing.dart';
import 'package:vintiora/features/product/presentation/bloc/favorite/favs_bloc.dart';
import 'package:vintiora/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:vintiora/features/product/presentation/widgets/enhanced_product_gallery.dart';
import 'package:vintiora/features/product/presentation/widgets/product_pricing_card.dart';
import 'package:vintiora/shared/components/app_wrapper.dart';
import 'package:vintiora/shared/widgets/animated_fade_scale.dart';
import 'package:vintiora/shared/widgets/app_loader.dart';
import 'package:vintiora/shared/widgets/error_view.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _galleryController;
  final ScrollController _scrollController = ScrollController();
  int _currentImageIndex = 0;
  int _quantity = 1;
  String? _selectedSize;
  String? _selectedVariant;
  bool _isSpecsExpanded = false;
  bool _isDescExpanded = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _galleryController = PageController(viewportFraction: 0.85);
    _loadProductWithDetails();

    // Initialize favorite status
    context.read<FavsBloc>().add(InitLike(widget.productId));
  }

  void _loadProductWithDetails() {
    context.read<ProductBloc>().add(LoadProductWithPricing(widget.productId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _galleryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  double _calculateAverageRating(List<ProductReview>? reviews) {
    if (reviews == null || reviews.isEmpty) return 0.0;
    final totalRating = reviews.fold<double>(0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isDark(context);

    return AppWrapper(
      statusBarColor: isDarkMode ? AppColors.grey8 : AppColors.primary2,
      navigationBarColor: AppColors.primary2,
      navigationBarIconBrightness: Brightness.light,
      appBar: CustomAppBar(
        title: 'Product Details',
        onBackPressed: Nav.pop,
        actions: [
          BlocSelector<FavsBloc, FavsState, bool>(
            selector: (state) => state.likedProductIds.contains(widget.productId),
            builder: (context, isLiked) {
              return GestureDetector(
                onTap: () => context.read<FavsBloc>().add(ToggleLike(widget.productId, false)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    size: 28,
                    color: isLiked ? (isDarkMode ? AppColors.primary : AppColors.darkPrimary) : (isDarkMode ? AppColors.grey4 : AppColors.grey6),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // Navigate to cart page
              Nav.push(Routes.cart);
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context, isDarkMode),
      child: _buildProductDetailContent(isDarkMode),
    );
  }

  Widget _buildProductDetailContent(bool isDarkMode) {
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) => previous.status != current.status || previous.productWithPricing != current.productWithPricing,
      builder: (context, state) {
        if (state.status == ProductsStatus.loading) {
          return const Center(child: AppLoader());
        } else if (state.status == ProductsStatus.error) {
          return ErrorView(
            message: state.errorMessage ?? 'Failed to load product details',
            onRetry: _loadProductWithDetails,
          );
        }

        final productWithPricing = state.productWithPricing;
        if (productWithPricing == null) {
          return const Center(child: Text('No product details available.'));
        }

        final product = productWithPricing.product;
        return RefreshIndicator(
          onRefresh: () async => _loadProductWithDetails(),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildProductHeroSection(productWithPricing),
              ),
              SliverToBoxAdapter(
                child: _buildProductHeader(productWithPricing),
              ),
              SliverToBoxAdapter(
                child: ProductPricingCard(pricing: productWithPricing.pricing),
              ),
              SliverToBoxAdapter(
                child: _buildStockAndVariants(productWithPricing),
              ),
              SliverToBoxAdapter(
                child: _buildProductTabs(productWithPricing),
              ),
              SliverToBoxAdapter(
                child: _buildReviews(productWithPricing),
              ),
              SliverToBoxAdapter(
                child: _buildRelatedProducts(productWithPricing),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductHeroSection(ProductWithPricing p) {
    final product = p.product;
    final isDarkMode = isDark(context);

    return Container(
      height: 320,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.grey8 : AppColors.primary2,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: EnhancedProductGallery(
        image: product.image,
        images: product.images,
        productName: product.name,
        defaultDiscount: product.defaultDiscount,
        defaultQuantity: product.defaultQuantity,
        stockStatus: product.stockStatus,
        isNewArrival: product.isNewArrival,
        heroTag: 'product_image_${product.id}',
      ),
    );
  }

  Widget _buildProductHeader(ProductWithPricing p) {
    final product = p.product;
    final isDarkMode = isDark(context);
    final avgRating = _calculateAverageRating(product.reviews);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Brand and Category
          Row(
            children: [
              Icon(Icons.business, size: 16, color: isDarkMode ? AppColors.grey4 : AppColors.grey6),
              const SizedBox(width: 4),
              Text(
                'Brand: ${product.brand}',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? AppColors.grey2 : AppColors.grey6,
                ),
              ),
              const SizedBox(width: 16),
              Icon(product.category.icon, size: 16, color: isDarkMode ? AppColors.grey4 : AppColors.grey6),
              const SizedBox(width: 4),
              Text(
                'Category: ${product.category.name}',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? AppColors.grey2 : AppColors.grey6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rating and Reviews
          if (product.reviews.isNotEmpty)
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < avgRating.floor() ? Icons.star : (index < avgRating ? Icons.star_half : Icons.star_border),
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
                const SizedBox(width: 8),
                Text(
                  avgRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${product.reviews.length} ${product.reviews.length == 1 ? 'review' : 'reviews'})',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? AppColors.grey2 : AppColors.grey6,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStockAndVariants(ProductWithPricing p) {
    final product = p.product;
    final isDarkMode = isDark(context);
    final isInStock = product.stockStatus == 'In Stock';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stock Status
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isInStock ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                product.stockStatus,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isInStock ? Colors.green : Colors.red,
                ),
              ),
              if (isInStock && product.defaultQuantity > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '(${product.defaultQuantity} available)',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? AppColors.grey2 : AppColors.grey6,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Size/Variant Selection
          if (product.variants.isNotEmpty) ...[
            // Group variants by type
            ...buildVariantSelectors(product),
            const SizedBox(height: 20),
          ],

          // Quantity Selection
          const Text(
            'Quantity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          QuantitySelector(
            quantity: _quantity,
            onChanged: (value) {
              setState(() {
                _quantity = value;
              });
            },
            minValue: 1,
            maxValue: isInStock ? product.defaultQuantity : 1,
          ),
        ],
      ),
    );
  }

  List<Widget> buildVariantSelectors(Product product) {
    // Group variants by type
    final Map<String, List<ProductVariant>> variantsByType = {};
    for (final variant in product.variants) {
      if (!variantsByType.containsKey(variant.type)) {
        variantsByType[variant.type] = [];
      }
      variantsByType[variant.type]!.add(variant);
    }

    return variantsByType.entries.map((entry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select ${entry.key}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: entry.value.map((variant) {
              final isSelected = entry.key.toLowerCase() == 'size' ? _selectedSize == variant.value : _selectedVariant == variant.value;

              return ChoiceChip(
                label: Text(variant.value),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (entry.key.toLowerCase() == 'size') {
                      _selectedSize = selected ? variant.value : null;
                    } else {
                      _selectedVariant = selected ? variant.value : null;
                    }
                  });
                },
                selectedColor: isDark(context) ? AppColors.primary : AppColors.primary.withAlpha(180),
                backgroundColor: isDark(context) ? AppColors.grey7 : AppColors.white2,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  Widget _buildProductTabs(ProductWithPricing p) {
    return Column(
      children: [
        // Tab Bar
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Description'),
            Tab(text: 'Specifications'),
            Tab(text: 'Similar Products'),
          ],
          labelColor: isDark(context) ? Colors.white : Colors.black,
          unselectedLabelColor: isDark(context) ? AppColors.grey4 : AppColors.grey6,
          indicatorColor: isDark(context) ? AppColors.primary : AppColors.primary,
        ),

        // Tab Content
        SizedBox(
          height: 250.h,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDescriptionTab(p),
              _buildSpecificationsTab(p),
              _buildSimilarProductsTab(p),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionTab(ProductWithPricing p) {
    final product = p.product;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description Title & Expand/Collapse
          GestureDetector(
            onTap: () {
              setState(() {
                _isDescExpanded = !_isDescExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Product Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _isDescExpanded ? Icons.expand_less : Icons.expand_more,
                  color: isDark(context) ? AppColors.grey2 : AppColors.grey6,
                ),
              ],
            ),
          ),

          // Description Content
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isDescExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                product.description,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: isDark(context) ? AppColors.grey2 : AppColors.grey7,
                ),
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),

          const SizedBox(height: 16),

          // Additional Description Content (if available)
          // if (product.longDescription != null && product.longDescription!.isNotEmpty)
          //   Text(
          //     product.longDescription!,
          //     style: TextStyle(
          //       fontSize: 14,
          //       height: 1.5,
          //       color: isDark(context) ? AppColors.grey3 : AppColors.grey6,
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsTab(ProductWithPricing p) {
    final product = p.product;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Specifications Title & Expand/Collapse
          GestureDetector(
            onTap: () {
              setState(() {
                _isSpecsExpanded = !_isSpecsExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Technical Specifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _isSpecsExpanded ? Icons.expand_less : Icons.expand_more,
                  color: isDark(context) ? AppColors.grey2 : AppColors.grey6,
                ),
              ],
            ),
          ),

          // Specifications Content
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isSpecsExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                border: TableBorder.all(
                  color: isDark(context) ? AppColors.grey7 : AppColors.grey3,
                  width: 1,
                ),
                children: [
                  _buildTableRow('Brand', product.brand),
                  _buildTableRow('Category', product.category.name),
                  if (product.alcoholContent > 0) _buildTableRow('Alcohol Content', '${product.alcoholContent}%'),
                  _buildTableRow('Weight', '${product.weight} kg'),
                  _buildTableRow(
                    'Dimensions',
                    '${product.dimensions.length} × ${product.dimensions.width} × ${product.dimensions.height} cm',
                  ),
                  _buildTableRow('Suppliers', product.suppliers.toString()),
                  _buildTableRow('Stock Status', product.stockStatus),
                  if (product.defaultQuantity > 0) _buildTableRow('Available Quantity', product.defaultQuantity.toString()),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark(context) ? AppColors.white : AppColors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(
              color: isDark(context) ? AppColors.grey2 : AppColors.grey7,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarProductsTab(ProductWithPricing p) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.status == ProductsStatus.pricingLoaded && state.products.isNotEmpty) {
          final similarProducts = state.products;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: similarProducts.length,
            itemBuilder: (context, index) {
              final similarProduct = similarProducts[index];
              return AnimatedFadeScale(
                delay: Duration(milliseconds: 50 * index),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          productId: similarProduct.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AppImage(
                              Constants.baseUrl + similarProduct.image,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  similarProduct.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${similarProduct.defaultPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDark(context) ? AppColors.primary : AppColors.darkPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Brand: ${similarProduct.brand}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark(context) ? AppColors.grey3 : AppColors.grey6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text(
              'No similar products found',
              style: TextStyle(
                color: isDark(context) ? AppColors.grey2 : AppColors.grey6,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildReviews(ProductWithPricing p) {
    final product = p.product;
    final reviews = product.reviews;

    if (reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '0',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildRatingStars(0),
                      const SizedBox(height: 4),
                      Text(
                        'No reviews yet',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark(context) ? AppColors.grey3 : AppColors.grey6,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      'Be the first to review this product!',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark(context) ? AppColors.grey4 : AppColors.grey6,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Customer Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (reviews.length > 3)
                TextButton(
                  onPressed: () {
                    // Navigate to all reviews
                    Nav.push(Routes.reviews, arguments: widget.productId);
                  },
                  child: Text(
                    'View All (${reviews.length})',
                    style: TextStyle(
                      color: isDark(context) ? AppColors.primary : AppColors.darkPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Review summary with stars
          _buildRatingSummary(reviews),
          const SizedBox(height: 16),

          // Individual reviews
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length > 3 ? 3 : reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return AnimatedFadeScale(
                delay: Duration(milliseconds: 100 * index),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isDark(context) ? AppColors.primary : AppColors.primary.withOpacity(0.2),
                                    radius: 20,
                                    child: Text(
                                      review.userId!.substring(0, 1).toUpperCase(),
                                      style: TextStyle(
                                        color: isDark(context) ? Colors.white : AppColors.darkPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          review.userId!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMM dd, yyyy').format(review.updatedAt),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark(context) ? AppColors.grey3 : AppColors.grey6,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildRatingStars(review.rating.toDouble()),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'review.title',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          review.comment ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: isDark(context) ? AppColors.grey2 : AppColors.grey7,
                          ),
                        ),
                        if (true) ...[
                          // if (review.photos.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 1,
                              // itemCount: review.photos.length,
                              itemBuilder: (context, photoIndex) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Open photo viewer
                                        Nav.push(Routes.gallery
                                            // images: review.photos.map((photo) => Constants.baseUrl + photo).toList(),
                                            // initialIndex: photoIndex,
                                            );
                                      },
                                      child: AppImage(
                                        Constants.baseUrl + product.image,
                                        // Constants.baseUrl + review.photos[photoIndex],
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        if (true) ...[
                          // if (review.verified) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.verified,
                                size: 16,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Verified Purchase',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Rating summary component
  Widget _buildRatingSummary(List<ProductReview> reviews) {
    final Map<int, int> ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    // Calculate rating distribution
    for (final review in reviews) {
      final rating = review.rating.round();
      if (ratingCounts.containsKey(rating)) {
        ratingCounts[rating] = ratingCounts[rating]! + 1;
      }
    }

    // Calculate average rating
    final avgRating = _calculateAverageRating(reviews);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Average rating display
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                avgRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildRatingStars(avgRating),
              const SizedBox(height: 4),
              Text(
                '${reviews.length} ${reviews.length == 1 ? 'review' : 'reviews'}',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark(context) ? AppColors.grey3 : AppColors.grey6,
                ),
              ),
            ],
          ),
        ),

        // Rating distribution
        Expanded(
          flex: 3,
          child: Column(
            children: List.generate(5, (index) {
              final ratingValue = 5 - index;
              final count = ratingCounts[ratingValue] ?? 0;
              final percentage = reviews.isEmpty ? 0.0 : count / reviews.length;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    Text(
                      '$ratingValue',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: isDark(context) ? AppColors.grey7 : AppColors.grey2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark(context) ? AppColors.primary : AppColors.darkPrimary,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 24,
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark(context) ? AppColors.grey3 : AppColors.grey6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : (index < rating ? Icons.star_half : Icons.star_border),
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  Widget _buildRelatedProducts(ProductWithPricing p) {
    // This should be implemented similar to the similar products tab
    // but with horizontally scrolling cards for related products
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.status != ProductsStatus.pricingLoaded || !state.relatedProducts.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'No related products found',
                    style: TextStyle(
                      color: isDark(context) ? AppColors.grey2 : AppColors.grey6,
                    ),
                  ),
                )
              ],
            ),
          );
        }

        final relatedProducts = state.relatedProducts;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'You May Also Like',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to related products
                        // Nav.toRelatedProducts(p.product.category.id);
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: isDark(context) ? AppColors.primary : AppColors.darkPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 240,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: relatedProducts.length,
                  itemBuilder: (context, index) {
                    final product = relatedProducts[index];
                    return AnimatedFadeScale(
                      delay: Duration(milliseconds: 100 * index),
                      child: SizedBox(
                        width: 160,
                        child: GestureDetector(
                          onTap: () => Nav.push(
                            Routes.productDetails,
                            arguments: product.id,
                          ),
                          child: Card(
                            margin: const EdgeInsets.all(4),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product image with discount/new badges
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: AppImage(
                                        Constants.baseUrl + product.image,
                                        height: 140,
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    // Discount badge
                                    if (product.defaultDiscount > 0)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade700,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '${product.defaultDiscount.toStringAsFixed(0)}% OFF',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    // New badge
                                    if (product.isNewArrival)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade700,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'NEW',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                // Product details
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '\$${product.defaultPrice.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isDark(context) ? AppColors.primary : AppColors.darkPrimary,
                                            ),
                                          ),
                                          if (product.defaultDiscount > 0) ...[
                                            const SizedBox(width: 4),
                                            Text(
                                              '\$${(product.defaultPrice / (1 - product.defaultDiscount / 100)).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                decoration: TextDecoration.lineThrough,
                                                color: isDark(context) ? AppColors.grey4 : AppColors.grey5,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            _calculateAverageRating(product.reviews).toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 12.0,
        bottom: 12.0 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.grey8 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          final productWithPricing = state.productWithPricing;
          if (productWithPricing == null) return const SizedBox.shrink();

          final product = productWithPricing.product;
          final pricing = productWithPricing.pricing;
          final effectivePrice = pricing.bestPrice;

          final cart = context.select((CartBloc bloc) => bloc.state.cart?.items) ?? [];
          final isInCart = cart.any((item) => item.product.id == widget.productId);

          return Row(
            children: [
              // Price display
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? AppColors.grey3 : AppColors.grey6,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${effectivePrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? AppColors.primary : AppColors.darkPrimary,
                          ),
                        ),
                        if (pricing.regularPrice > effectivePrice) ...[
                          const SizedBox(width: 6),
                          Text(
                            '\$${pricing.regularPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: isDarkMode ? AppColors.grey4 : AppColors.grey5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Add to cart button
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart ? (isDarkMode ? AppColors.grey6 : AppColors.grey4) : (isDarkMode ? AppColors.primary : AppColors.darkPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: product.stockStatus != 'In Stock'
                      ? null
                      : () {
                          if (isInCart) {
                            // Navigate to cart
                            Nav.push(Routes.cart);
                          } else {
                            // Add to cart
                            context.read<CartBloc>().add(
                                  AddToCartEvent(
                                    productId: product.id,
                                    quantity: _quantity,
                                    // selectedSize: _selectedSize,
                                    // selectedVariant: _selectedVariant,
                                    // pricing: pricing,
                                  ),
                                );

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added to your cart'),
                                action: SnackBarAction(
                                  label: 'VIEW CART',
                                  onPressed: () => Nav.push(Routes.cart),
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                  icon: Icon(
                    isInCart ? Icons.shopping_cart : Icons.add_shopping_cart_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    isInCart ? 'GO TO CART' : 'ADD TO CART',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Quantity Selector Widget
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onChanged;
  final int minValue;
  final int maxValue;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.minValue = 1,
    this.maxValue = 99,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isDark(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode ? AppColors.grey6 : AppColors.grey3,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          _buildButton(
            context: context,
            icon: Icons.remove,
            onPressed: quantity > minValue ? () => onChanged(quantity - 1) : null,
          ),

          // Quantity display
          Container(
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isDarkMode ? AppColors.grey6 : AppColors.grey3,
                ),
                right: BorderSide(
                  color: isDarkMode ? AppColors.grey6 : AppColors.grey3,
                ),
              ),
            ),
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Increase button
          _buildButton(
            context: context,
            icon: Icons.add,
            onPressed: quantity < maxValue ? () => onChanged(quantity + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    final isDarkMode = isDark(context);

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: onPressed == null ? (isDarkMode ? AppColors.grey7 : AppColors.grey2) : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 18,
          color: onPressed == null ? (isDarkMode ? AppColors.grey5 : AppColors.grey4) : (isDarkMode ? AppColors.primary : AppColors.darkPrimary),
        ),
      ),
    );
  }
}

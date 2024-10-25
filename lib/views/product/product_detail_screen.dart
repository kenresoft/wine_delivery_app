import 'package:badges/badges.dart' as badges;
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/bloc/product/favorite/favs_bloc.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import '../../model/product.dart';
import '../../model/reviews.dart';
import '../../utils/helpers.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  // final PopularityRepository? popularityRepo;

  const ProductDetailScreen({
    super.key,
    required this.product,
    // this.popularityRepo,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  String _selectedSize = '15 ml';
  late TabController _tabController;
  late PageController _pageController;

/*  final List<String> productVariants = [
    'Scarlett Whitening',
    'Ponds White Series',
    'Emina Bright Stuff',
    'Spanish Desperadoes',
  ];*/

  int _currentPage = 0; // To track the current product variant shown

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(viewportFraction: 0.8); // For the slider
    context.read<FavsBloc>().add(InitLike(widget.product.id!));
    final similarProducts = widget.product.relatedProducts;
    final productIds = similarProducts?.map((e) => e.product!).toList();
    context.read<ProductBloc>().add(GetProductsByIds(productIds!));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final popularity = widget.popularityRepo?.getPopularity(widget.wine);

    double calculateAverageRating(List<Reviews>? reviews) {
      if (reviews!.isEmpty) return 0.0;
      final totalRating = reviews.fold<double>(
        0,
        (sum, review) => sum + review.rating!,
      );
      return totalRating / reviews.length;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name!),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 350.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color(context).primaryContainerColor,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 300.h,
                    child: Hero(
                      tag: widget.product.id!,
                      flightShuttleBuilder: (_, animation, __, ___, ____) {
                        return FadeTransition(
                          opacity: animation,
                          child: Image(
                            image: Utils.networkImage(widget.product.image),
                            height: 240.h,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                      child: condition(
                        widget.product.images!.isNotEmpty,
                        PageView.builder(
                          padEnds: true,
                          controller: _pageController,
                          itemCount: widget.product.images?.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return _buildProductVariantCard(widget.product.images?[index]);
                          },
                        ),
                        _buildProductVariantCard(null),
                      ),
                    ),
                  ),
                  // Custom Indicator for product variants
                  Flexible(child: _buildCustomIndicator()),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    widget.product.name!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Price and Reviews
                  _buildPriceRating(calculateAverageRating),

                  // SIZE Options
                  Text(
                    'Select Size',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // CHIPS
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildSizeOption('15 ml'),
                        SizedBox(width: 16),
                        _buildSizeOption('25 ml'),
                        SizedBox(width: 16),
                        _buildSizeOption('50 ml'),
                      ],
                    ),
                  ),

                  // TABS for Description, How to Use, Reviews
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Description'),
                      Tab(text: 'Details'),
                      Tab(text: 'Similar Wines'),
                    ],
                  ),

                  // TAB VIEWS
                  SizedBox(
                    height: 125.h,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.description!,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('Brand: ${widget.product.brand}'),
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildDetailRow('Alcohol Content: ', '${widget.product.alcoholContent?.toStringAsFixed(1)}%'),
                              // const SizedBox(height: 10),
                              buildDetailRow('Length: ', '${widget.product.dimensions?.length}'),
                              buildDetailRow('Width: ', '${widget.product.dimensions?.width}'),
                              buildDetailRow('Height: ', '${widget.product.dimensions?.height}'),
                              buildDetailRow('Weight: ', '${widget.product.weight}'),

                              Text(
                                '${widget.product.suppliers}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              /*Text(
                                'Popularity: $popularity',
                                style: const TextStyle(
                                  fontSize: 18,
                                  // color: Colors.black87,
                                ),
                              ),*/
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Available Sizes: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '{widget.wine.variants?[0].value}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // SIMILAR WINE
                        _buildSimilarWine(),
                      ],
                    ),
                  ),

                  // REVIEWS
                  _buildReviews(),
                ],
              ),
            ),
          ),
        ],
      ),
      // ADD TO CART
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Row buildDetailRow(String title, String subtitle) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(subtitle),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context.read<CartBloc>().add(
                      AddToCart(
                        productId: widget.product.id!,
                        quantity: 1,
                        cb: () {
                          logger.i('ITEM ADDED TO CART!');
                          snackBar(context, 'ITEM ADDED TO CART!');
                        },
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15.0),
                /*backgroundColor: Colors.redAccent,*/
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartUpdated) {
                    return Text(
                      '$state ${widget.product.name} added to cart',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      ),
                    );
                  } else {
                    return const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          BlocBuilder<FavsBloc, FavsState>(
            builder: (context, state) {
              return switch (state) {
                FavsLoaded() => ElevatedButton(
                    onPressed: () async {
                      context.read<FavsBloc>().add(ToggleLike(widget.product.id!, false));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: condition(
                      state.isLiked,
                      Icon(
                        Icons.favorite,
                        color: color(context).onSurfaceTextColor,
                      ),
                      Icon(
                        Icons.favorite_border,
                        color: color(context).onSurfaceTextColor,
                      ),
                    ),
                  ),
                _ => SizedBox(),
              };
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarWine() {
    // final similarWines = widget.wine.relatedProducts /*?.multiply(times: 6)*/;
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          final similarWines = state.products;
          return Column(
            children: [
              SizedBox(
                height: 110.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: similarWines.length,
                  itemBuilder: (context, index) {
                    final similarWine = similarWines[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to similar wine detail page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              product: similarWine,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 180),
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                    child: LimitedBox(
                                      maxWidth: 50,
                                      child: Image(
                                        image: Utils.networkImage(similarWine.image),
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                // const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    similarWine.name!,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
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
          );
        } else {
          return Center(
            child: Text('No matches found!'),
          );
        }
      },
    );
  }

  Widget _buildReviews() {
    // storageRepository.getRefreshToken().then(logger.t);
    final reviews = widget.product.reviews?.multiply(times: 6).take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 12),
          shrinkWrap: true,
          itemCount: reviews?.length,
          // itemCount: widget.wine.reviews.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final review = reviews?[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  // Handle review tap
                },
                child: Card(
                  child: Container(
                    width: 200,
                    height: 100,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              color: color(context).onSurfaceTextColor,
                              child: CircleAvatar(
                                radius: 13,
                                backgroundImage: AssetImage(Constants.imagePlaceholder),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              review!.user!.username!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            review.comment!,
                            style: const TextStyle(fontSize: 14),
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
      ],
    );
  }

  Widget _buildPriceRating(double Function(List<Reviews>? reviews) calculateAverageRating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\$${widget.product.defaultPrice!.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              // color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star),
              Text(
                calculateAverageRating(widget.product.reviews).toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 18,
                  // color: Colors.grey,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '(${widget.product.reviews?.length} reviews)',
                style: const TextStyle(
                  fontSize: 16,
                  // color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget for Product Variants Card
  Widget _buildProductVariantCard(String? image) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withAlpha(80),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: Utils.networkImage(image),
                  height: 240.h,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 12.h),
                Flexible(
                  child: Text(
                    widget.product.name!,
                    // variantName[index],
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Quantity Badge
          Positioned(
            top: 0,
            right: 0,
            child: badges.Badge(
              badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
              badgeStyle: badges.BadgeStyle(
                badgeColor: Utils.getStockStatusColor(
                  widget.product.stockStatus!,
                ), // Get color based on stock status
                shape: badges.BadgeShape.square,
                borderRadius: BorderRadius.only(topRight: Radius.circular(8)),
              ),
              badgeContent: Text(
                '${widget.product.defaultDiscount!.toStringAsFixed(1)}% Off',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          Positioned(
            top: 34,
            right: 0,
            child: badges.Badge(
              badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
              badgeStyle: badges.BadgeStyle(
                badgeColor: colorScheme(context).tertiary,
                shape: badges.BadgeShape.square,
                // borderRadius: BorderRadius.only(topRight: Radius.circular(8)),
              ),
              badgeContent: Text(
                '${widget.product.defaultQuantity!.toString()} Remaining',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    return ChoiceChip(
      label: Text(size),
      selected: _selectedSize == size,
      onSelected: (selected) {
        setState(() {
          _selectedSize = size;
        });
      },
      selectedColor: color(context).tertiaryColor,
      backgroundColor: color(context).cardColor,
    );
  }

  // Custom Indicator Builder
  Widget _buildCustomIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.product.images!.length,
        (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            height: 4.0,
            width: _currentPage == index ? 24.0 : 12.0,
            // Active dot is wider
            decoration: BoxDecoration(
              color: _currentPage == index ? color(context).onSurfaceTextColor : color(context).surfaceTintColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
        },
      ),
    );
  }
}
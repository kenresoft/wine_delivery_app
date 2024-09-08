import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/bloc/cart/cart_bloc.dart';

import '../../bloc/product/favorite/like/like_bloc.dart';
import '../../model/product.dart';
import '../../repository/popularity_repository.dart';
import '../../repository/similar_wines_repository.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product wine;

  final SimilarWinesRepository similarWinesRepo;
  final PopularityRepository popularityRepo;

  const ProductDetailScreen({
    super.key,
    required this.wine,
    required this.similarWinesRepo,
    required this.popularityRepo,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  /*Future<void> _toggleFavoriteStatus() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (isFavorite) {
        await widget.favoritesRepository
            .removeFavorite(widget.userId, widget.product.id);
      } else {
        await widget.favoritesRepository
            .addFavorite(widget.userId, widget.product.id);
      }
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (error) {
      // Handle the error (show a snackbar, alert, etc.)
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
*/
  @override
  void initState() {
    super.initState();
    context.read<LikeBloc>().add(Init(widget.wine.id));
  }

  @override
  Widget build(BuildContext context) {
    final similarWines = widget.similarWinesRepo.findSimilarWines(widget.wine);
    final popularity = widget.popularityRepo.getPopularity(widget.wine);

    double calculateAverageRating(List<Review> reviews) {
      if (reviews.isEmpty) return 0.0;
      final totalRating = reviews.fold<double>(0, (sum, review) => sum + review.rating);
      return totalRating / reviews.length;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.wine.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Handle adding to favorites
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffF4F4F4),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(90)),
              ),
              child: Hero(
                tag: widget.wine.image,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    'assets/images/${widget.wine.image}',
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.wine.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${widget.wine.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(
                      calculateAverageRating(widget.wine.reviews).toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '(${widget.wine.reviews.length} reviews)',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Alcohol Content: ${widget.wine.alcoholContent.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Popularity: $popularity',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Available Sizes: Small, Medium, Large',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.wine.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.wine.reviews.length,
                itemBuilder: (context, index) {
                  final review = widget.wine.reviews[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Handle review tap
                      },
                      child: Card(
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                review.user.username,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                review.review,
                                style: const TextStyle(
                                  fontSize: 14,
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

            const SizedBox(height: 10),

            // TODO
            const Text(
              'Similar Wines',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: similarWines.length,
                itemBuilder: (context, index) {
                  final similarWine = similarWines[index];
                  print(similarWines);

                  ///4
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to similar wine detail page
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              similarWine.image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            similarWine.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(AddToCart(productId: widget.wine.id, quantity: 1));
                  print('ITEM ADDED TO CART!');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15.0),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartUpdated) {
                      return Text(
                        '$state ${widget.wine.name} added to cart',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            BlocBuilder<LikeBloc, LikeState>(
              builder: (context, state) {
                return switch(state){
                  InitialState() => ElevatedButton(
                      onPressed: () async {
                        context.read<LikeBloc>().add(Like(widget.wine.id));
                        // print(isLiked);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: state.isLiked
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.redAccent,
                            ),
                    ),
                  ToggleState() => ElevatedButton(
                      onPressed: () async {
                        // Handle adding to favorites
                        context.read<LikeBloc>().add(Like(widget.wine.id));
                        // print(isLiked);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: state.isLiked
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.redAccent,
                            ),
                    ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
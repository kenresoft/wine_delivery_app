/*
import '../model/product.dart';

class SimilarWinesRepository {
  final List<Product> allWines;

  SimilarWinesRepository({required this.allWines});

  List<Product> findSimilarWines(Product product, {int limit = 5}) {
    return allWines
        .where((otherWine) {
          return otherWine != product && _isSimilar(product, otherWine);
        })
        .take(limit)
        .toList();
  }

  bool _isSimilar(Product product1, Product product2) {
    return product1.category == product2.category &&
        (product1.price - product2.price).abs() < 10 && // Allow a price difference of 10 units
        (product1.rating - product2.rating).abs() < 1.0; // Allow a rating difference of 1.0
  }
}
*/


import '../model/product.dart';

class SimilarWinesRepository {
  final List<Product> allWines;

  SimilarWinesRepository({required this.allWines});

  /// Finds similar wines based on category, price, and rating.
  /// [limit] specifies the maximum number of similar wines to return.
  /// [priceDifferenceThreshold] specifies the allowed price difference.
  /// [ratingDifferenceThreshold] specifies the allowed rating difference.
  List<Product> findSimilarWines(
      Product product, {
        int limit = 5,
        double priceDifferenceThreshold = 10.0,
        double ratingDifferenceThreshold = 1.0,
      }) {
    return allWines
        .where((otherWine) => _isSimilar(
      product,
      otherWine,
      priceDifferenceThreshold: priceDifferenceThreshold,
      ratingDifferenceThreshold: ratingDifferenceThreshold,
    ))
        .take(limit)
        .toList();
  }

  /// Determines if two wines are similar based on category, price, and average rating.
  bool _isSimilar(
      Product product1,
      Product product2, {
        required double priceDifferenceThreshold,
        required double ratingDifferenceThreshold,
      }) {
    return product1 != product2 &&
        product1.category.id == product2.category.id &&
        (product1.price - product2.price).abs() <= priceDifferenceThreshold &&
        (_calculateAverageRating(product1.reviews) -
            _calculateAverageRating(product2.reviews))
            .abs() <= ratingDifferenceThreshold;
  }

  /// Calculates the average rating for a list of reviews.
  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    final totalRating = reviews.fold<double>(
        0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }
}

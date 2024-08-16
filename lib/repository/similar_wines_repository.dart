import '../model/wine.dart';

class SimilarWinesRepository {
  final List<Wine> allWines;

  SimilarWinesRepository({required this.allWines});

  List<Wine> findSimilarWines(Wine wine, {int limit = 5}) {
    return allWines
        .where((otherWine) {
          return otherWine != wine && _isSimilar(wine, otherWine);
        })
        .take(limit)
        .toList();
  }

  bool _isSimilar(Wine wine1, Wine wine2) {
    return wine1.category == wine2.category &&
        (wine1.price - wine2.price).abs() < 10 && // Allow a price difference of 10 units
        (wine1.rating - wine2.rating).abs() < 1.0; // Allow a rating difference of 1.0
  }
}

import '../model/product.dart';

class PopularityRepository {
  final Map<String, int> purchaseCountMap;
  final Map<String, int> reviewCountMap;

  PopularityRepository({
    required this.purchaseCountMap,
    required this.reviewCountMap,
  });

  int getPopularity(Product wine) {
    int purchaseCount = purchaseCountMap[wine.name] ?? 0;
    int reviewCount = reviewCountMap[wine.name] ?? 0;
    return purchaseCount + reviewCount;
  }

  void updatePopularity(Product wine, int purchases, int reviews) {
    purchaseCountMap[wine.name!] = (purchaseCountMap[wine.name] ?? 0) + purchases;
    reviewCountMap[wine.name!] = (reviewCountMap[wine.name] ?? 0) + reviews;
  }

  List<Product> getPopularWines(List<Product> allWines, {int limit = 5}) {
    allWines.sort(
      (a, b) => getPopularity(b).compareTo(getPopularity(a)),
    );
    return allWines.take(limit).toList();
  }
}

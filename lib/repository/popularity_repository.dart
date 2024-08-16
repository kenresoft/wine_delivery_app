import '../model/wine.dart';

class PopularityRepository {
  final Map<String, int> purchaseCountMap;
  final Map<String, int> reviewCountMap;

  PopularityRepository({
    required this.purchaseCountMap,
    required this.reviewCountMap,
  });

  int getPopularity(Wine wine) {
    int purchaseCount = purchaseCountMap[wine.name] ?? 0;
    int reviewCount = reviewCountMap[wine.name] ?? 0;
    return purchaseCount + reviewCount;
  }

  void updatePopularity(Wine wine, int purchases, int reviews) {
    purchaseCountMap[wine.name] = (purchaseCountMap[wine.name] ?? 0) + purchases;
    reviewCountMap[wine.name] = (reviewCountMap[wine.name] ?? 0) + reviews;
  }

  List<Wine> getPopularWines(List<Wine> allWines, {int limit = 5}) {
    allWines.sort(
      (a, b) => getPopularity(b).compareTo(getPopularity(a)),
    );
    return allWines.take(limit).toList();
  }
}

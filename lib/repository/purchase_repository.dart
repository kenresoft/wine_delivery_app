import 'package:wine_delivery_app/utils/utils.dart';

import '../model/purchase.dart';
import '../model/product.dart';

class PurchaseRepository {
  // Private constructor
  PurchaseRepository._();

  // Static private instance variable
  static final PurchaseRepository _instance = PurchaseRepository._();

  // Getter for the singleton instance
  static PurchaseRepository getInstance() {
    return _instance;
  }

  List<Purchase> purchases = [];

  int _purchaseIdCounter = 2000;

  String _generatePurchaseId() {
    String newPurchaseId = '';
    bool isUnique = false;
    while (!isUnique) {
      newPurchaseId = 'PUR${_purchaseIdCounter++}';
      isUnique = !purchases.any((purchase) {
        return purchase.purchaseId == newPurchaseId;
      });
    }
    return newPurchaseId;
  }

  void addPurchase(Product wine, int quantity, DateTime date) {
    Purchase newPurchase = Purchase(
      purchaseId: _generatePurchaseId(),
      wine: wine,
      quantity: quantity,
      purchaseDate: date,
    );
    purchases.add(newPurchase);
    'Purchase added!'.toast;
  }

  void deletePurchase(String purchaseId) {
    Purchase? purchaseToDelete = purchases.firstWhere((purchase) {
      return purchase.purchaseId == purchaseId;
    }, orElse: () => Purchase.empty());
    if (purchaseToDelete.purchaseId.isNotEmpty) {
      purchases.remove(purchaseToDelete);
      'Purchase deleted!'.toast;
    } else {
      'Purchase not found!'.toast;
    }
  }

  void deleteAllPurchases() {
    purchases.clear();
    'All purchases deleted!'.toast;
  }

  Purchase getPurchaseById(String purchaseId) {
    Purchase? purchase = purchases.firstWhere((purchase) {
      return purchase.purchaseId == purchaseId;
    }, orElse: () => Purchase.empty());
    return purchase;
  }

  List<Purchase> getPurchasesByWine(Product wine) {
    return purchases.where((purchase) {
      return purchase.wine == wine;
    }).toList();
  }

  List<Purchase> getPurchasesByDate(DateTime date) {
    return purchases.where((purchase) {
      return purchase.purchaseDate.isSameDate(date);
    }).toList();
  }
}

final PurchaseRepository purchaseManager = PurchaseRepository.getInstance();

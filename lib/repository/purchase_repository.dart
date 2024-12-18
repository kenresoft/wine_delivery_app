import 'package:wine_delivery_app/utils/extensions.dart';

import '../model/product.dart';
import '../model/purchase.dart';

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
      product: wine,
      quantity: quantity,
      purchaseDate: date,
    );
    purchases.add(newPurchase);
    'Purchase added!'.toasts;
  }

  void deletePurchase(String purchaseId) {
    Purchase? purchaseToDelete = purchases.firstWhere((purchase) {
      return purchase.purchaseId == purchaseId;
    }, orElse: () => Purchase.empty());
    if (purchaseToDelete.purchaseId.isNotEmpty) {
      purchases.remove(purchaseToDelete);
      'Purchase deleted!'.toasts;
    } else {
      'Purchase not found!'.toasts;
    }
  }

  void deleteAllPurchases() {
    purchases.clear();
    'All purchases deleted!'.toasts;
  }

  Purchase getPurchaseById(String purchaseId) {
    Purchase? purchase = purchases.firstWhere(
      (purchase) => purchase.purchaseId == purchaseId,
      orElse: () => Purchase.empty(),
    );
    return purchase;
  }

  List<Purchase> getPurchasesByWine(Product wine) {
    return purchases.where((purchase) => purchase.product == wine).toList();
  }

  List<Purchase> getPurchasesByDate(DateTime date) {
    return purchases.where((purchase) => purchase.purchaseDate.isSameDate(date)).toList();
  }
}

final PurchaseRepository purchaseManager = PurchaseRepository.getInstance();

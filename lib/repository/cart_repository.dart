import '../model/cart_item.dart';

class CartRepository {
  CartRepository._();

  static final CartRepository _instance = CartRepository._();

  // Getter for the singleton instance
  static CartRepository getInstance() {
    return _instance;
  }

  List<CartItem> cartItems = [];

  void addToCart(String itemName, double itemPrice, String imageUrl, int quantity, double purchaseCost) {
    // Check if the item already exists in the cart
    bool itemExists = false;
    for (var item in cartItems) {
      if (item.itemName == itemName) {
        itemExists = true;
        break;
      }
    }

    if (!itemExists) {
      cartItems.add(CartItem(
        itemName: itemName,
        itemPrice: itemPrice,
        quantity: quantity,
        imageUrl: imageUrl,
        purchaseCost: purchaseCost,
      ));
    }
  }

  void removeFromCart(String itemName) {
    cartItems.removeWhere((item) => item.itemName == itemName);
  }

  void increaseQuantity(int index) {
    cartItems[index] = cartItems[index].copyWith(quantity: cartItems[index].quantity + 1);
  }

  void decreaseQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index] = cartItems[index].copyWith(quantity: cartItems[index].quantity - 1);
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item.itemPrice * item.quantity;
    }
    return totalPrice;
  }

  double calculatePurchaseCost() {
    Set<String> uniqueItems = <String>{}; // Store unique item names
    double totalPurchaseCost = 0;
    for (var item in cartItems) {
      if (!uniqueItems.contains(item.itemName)) {
        totalPurchaseCost += item.purchaseCost;
        uniqueItems.add(item.itemName); // Add item name to unique set
      }
    }
    return totalPurchaseCost;
  }
}

// Usage:
// Access the singleton instance using CartManager.getInstance()
final CartRepository cartManager = CartRepository.getInstance();

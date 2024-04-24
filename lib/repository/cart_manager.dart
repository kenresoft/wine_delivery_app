import '../model/cart_item.dart';

class CartManager {
  // Private constructor
  CartManager._();

  // Static private instance variable
  static final CartManager _instance = CartManager._();

  // Getter for the singleton instance
  static CartManager getInstance() {
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
        // Set initial quantity to 1 for new items
        imageUrl: imageUrl,
        purchaseCost: purchaseCost, // Set purchase cost per unique item
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
final CartManager cartManager = CartManager.getInstance();

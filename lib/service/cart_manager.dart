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

  void addToCart(String itemName, double itemPrice, int quantity) {
    cartItems.add(CartItem(
      itemName: itemName,
      itemPrice: itemPrice,
      quantity: quantity,
    ));
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item.itemPrice * item.quantity;
    }
    return totalPrice;
  }
}

// Usage:
// Access the singleton instance using CartManager.getInstance()
final CartManager cartManager = CartManager.getInstance();

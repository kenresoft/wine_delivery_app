class CartItem {
  final String itemName;
  final double itemPrice;
  int quantity;
  final String imageUrl; // New field for drink image URL
  double purchaseCost; // New field for purchase cost

  CartItem({
    required this.itemName,
    required this.itemPrice,
    required this.quantity,
    required this.imageUrl,
    required this.purchaseCost,
  });
}

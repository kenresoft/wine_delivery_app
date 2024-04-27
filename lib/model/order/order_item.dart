part of 'order.dart';

class OrderItem {
  final String itemName;
  final double itemPrice;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.itemName,
    required this.itemPrice,
    required this.quantity,
    required this.imageUrl,
  });
}
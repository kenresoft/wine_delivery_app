part of 'order.dart';

class OrderItem {
  final String productId;
  final int quantity;
  final String id;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.id,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product'],
      quantity: json['quantity'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': productId,
      'quantity': quantity,
      '_id': id,
    };
  }
}
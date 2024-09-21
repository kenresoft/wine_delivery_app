import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String productId;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': productId,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [productId, quantity];

  @override
  bool get stringify => true;
}
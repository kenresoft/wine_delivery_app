import 'package:equatable/equatable.dart';

import 'product.dart';

class CartItem extends Equatable{
  final String? id;
  final int? quantity;
  final Product? product;

  const CartItem({this.id, this.quantity, this.product});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'],
      quantity: json['quantity'],
      product: Product.fromJson(json['product']),
    );
  }

  @override
  List<Object?> get props => [id, quantity, product];

  @override
  bool get stringify => true;
}
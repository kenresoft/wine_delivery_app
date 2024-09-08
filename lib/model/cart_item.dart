/*
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String itemName;
  final double itemPrice;
  final int quantity;
  final String imageUrl;
  final double purchaseCost;

  const CartItem({
    required this.itemName,
    required this.itemPrice,
    required this.quantity,
    required this.imageUrl,
    required this.purchaseCost,
  });

  CartItem copyWith({
    String? itemName,
    double? itemPrice,
    int? quantity,
    String? imageUrl,
    double? purchaseCost,
  }) {
    return CartItem(
      itemName: itemName ?? this.itemName,
      itemPrice: itemPrice ?? this.itemPrice,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      purchaseCost: purchaseCost ?? this.purchaseCost,
    );
  }

  @override
  List<Object?> get props => [itemName, itemPrice, quantity, imageUrl, purchaseCost];

  @override
  bool get stringify => true; // Set stringify to true for better debugging
}
*/

import 'package:wine_delivery_app/model/product.dart';

class Cart {
  String? id;
  int? quantity;
  String? product;

  Cart({this.id, this.quantity, this.product});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['_id'],
      quantity: json['quantity'],
      product: json['product'],
    );
  }
}

class CartItem {
  String? id;
  int? quantity;
  Product? product;

  CartItem({this.id, this.quantity, this.product});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'],
      quantity: json['quantity'],
      product: Product.fromJson(json['product']),
    );
  }
}
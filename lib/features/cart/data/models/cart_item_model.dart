import 'package:vintiora/features/cart/domain/entities/cart_item.dart';
import 'package:vintiora/features/product/data/models/product_model.dart';

class CartItemModel extends CartItem {
  // final String id;
  // final ProductModel product;
  // final int quantity;

  const CartItemModel({
    required super.id,
    required super.product,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['_id'],
      product: ProductModel.fromCart(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'product': (product as ProductModel).toJson(),
      'quantity': quantity,
    };
  }

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity];
}

import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final String? id;
  final int? quantity;
  final String? product;

  const Cart({this.id, this.quantity, this.product});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['_id'],
      quantity: json['quantity'],
      product: json['product'],
    );
  }

  @override
  List<Object?> get props => [id, quantity, product];

  @override
  bool get stringify => true;
}

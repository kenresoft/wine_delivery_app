import 'package:equatable/equatable.dart';
import 'package:wine_delivery_app/model/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> cartItems;

  const CartState({required this.cartItems});

  @override
  List<Object?> get props => [cartItems];
}

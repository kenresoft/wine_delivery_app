part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class AddToCartEvent extends CartEvent {
  final CartItem cartItem;

  const AddToCartEvent(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}

class RemoveFromCartEvent extends CartEvent {
  final String itemName;

  const RemoveFromCartEvent(this.itemName);

  @override
  List<Object?> get props => [itemName];
}
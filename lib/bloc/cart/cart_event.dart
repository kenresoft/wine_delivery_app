part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class Initial extends CartEvent {}

class GetCartItems extends CartEvent {
  final String? couponCode;

  const GetCartItems({this.couponCode});

  @override
  List<Object?> get props => [couponCode];
}

class AddToCart extends CartEvent {
  final String productId;
  final int quantity;

  const AddToCart({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class UpdateCartItem extends CartEvent {
  final String itemId;
  final int quantity;

  const UpdateCartItem({required this.itemId, required this.quantity});

  @override
  List<Object?> get props => [itemId, quantity];
}

class RemoveFromCart extends CartEvent {
  final String itemId;

  const RemoveFromCart({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class RemoveAllFromCart extends CartEvent {
  const RemoveAllFromCart();
}

class IncrementCartItem extends CartEvent {
  final String itemId;

  const IncrementCartItem({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class DecrementCartItem extends CartEvent {
  final String itemId;

  const DecrementCartItem({required this.itemId});

  @override
  List<Object?> get props => [];
}

class GetTotalPrice extends CartEvent {}

class IsProductInCart extends CartEvent {
  final String productId;

  const IsProductInCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/*
class AddItemToCart extends CartEvent {
  final CartItem cartItem;

  const AddItemToCart(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}

class RemoveItemFromCart extends CartEvent {
  final String itemName;

  const RemoveItemFromCart(this.itemName);

  @override
  List<Object?> get props => [itemName];
}

class RemoveAllFromCart extends CartEvent {
  const RemoveAllFromCart();

  @override
  List<Object?> get props => [];
}*/

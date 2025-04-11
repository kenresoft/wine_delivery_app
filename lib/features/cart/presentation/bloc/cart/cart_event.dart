part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class GetCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final String productId;
  final int quantity;

  const AddToCartEvent({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

class IncrementCartItemEvent extends CartEvent {
  final String itemId;

  const IncrementCartItemEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class DecrementCartItemEvent extends CartEvent {
  final String itemId;

  const DecrementCartItemEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class RemoveCartItemEvent extends CartEvent {
  final String itemId;

  const RemoveCartItemEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class ApplyCouponEvent extends CartEvent {
  final String couponCode;

  const ApplyCouponEvent({required this.couponCode});

  @override
  List<Object?> get props => [couponCode];
}

class RemoveCouponEvent extends CartEvent {}

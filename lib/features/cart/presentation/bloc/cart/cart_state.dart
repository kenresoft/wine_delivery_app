part of 'cart_bloc.dart';

enum CartStatus { initial, loading, success, error }

class CartState extends Equatable {
  final CartStatus status;
  final Cart? cart;
  final String? message;
  final bool itemRemoved;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.message,
    this.itemRemoved = false,
  });

  CartState copyWith({
    CartStatus? status,
    Cart? cart,
    String? message,
    bool? itemRemoved,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      message: message ?? this.message,
      itemRemoved: itemRemoved ?? this.itemRemoved,
    );
  }

  @override
  List<Object?> get props => [status, cart, message, itemRemoved];
}

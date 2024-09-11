part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object?> get props => [];
}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final double totalPrice;
  final String? couponCode;

  const CartLoaded({
    required this.cartItems,
    required this.totalPrice,
    this.couponCode,
  });
  @override
  List<Object?> get props => [cartItems, totalPrice, couponCode];
}

class CartUpdated extends CartState {
  final String? message;

  const CartUpdated({this.message});

  @override
  List<Object?> get props => [message];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartTotalPriceLoaded extends CartState {
  final double totalPrice;

  const CartTotalPriceLoaded(this.totalPrice);

  @override
  List<Object?> get props => [totalPrice];
}

class ProductInCart extends CartState {
  final bool productInCart;

  const ProductInCart(this.productInCart);

  @override
  List<Object?> get props => [productInCart];
}
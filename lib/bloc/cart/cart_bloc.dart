import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/service/cart_manager.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(cartItems: cartManager.cartItems)) {
    on<AddToCartEvent>((event, emit) {
      cartManager.addToCart(
        event.cartItem.itemName,
        event.cartItem.itemPrice,
        event.cartItem.imageUrl,
        event.cartItem.quantity,
        event.cartItem.purchaseCost,
      );
      emit(CartState(cartItems: cartManager.cartItems));
    });

    on<RemoveFromCartEvent>((event, emit) {
      cartManager.removeFromCart(event.itemName);
      emit(CartState(cartItems: cartManager.cartItems));
    });
  }
}

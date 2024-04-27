import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/model/cart_item.dart';

import '../../repository/cart_repository.dart';

part 'cart_event.dart';

part 'cart_state.dart';

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
      emit(CartState(cartItems: List.of(cartManager.cartItems)));
    });

    on<RemoveFromCartEvent>((event, emit) {
      cartManager.removeFromCart(event.itemName);
      emit(CartState(cartItems: List.of(cartManager.cartItems)));
    });
  }
}


/*
* final CartManager cartRepository;

  CartBloc({required this.cartRepository}) : super(CartState(cartItems: cartRepository.cartItems)) {
    on<AddToCartEvent>((event, emit) {
      cartRepository.addToCart(
        event.cartItem.itemName,
        event.cartItem.itemPrice,
        event.cartItem.imageUrl,
        event.cartItem.quantity,
        event.cartItem.purchaseCost,
      );
      //'add'.toast;
      log('message');
      emit(CartState(cartItems: List.from(cartRepository.cartItems)));
    });

    on<RemoveFromCartEvent>((event, emit) {
      cartRepository.removeFromCart(event.itemName);
      emit(CartState(cartItems: cartRepository.cartItems));
    });
  }
  * */
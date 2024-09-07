import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/model/cart_item.dart';
import 'package:wine_delivery_app/utils/prefs.dart';

import '../../repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartInitial()) {
    on<GetCartItems>(getCartItems);
    on<AddToCart>(addToCart);
    on<UpdateCartItem>(updateCartItem);
    on<RemoveFromCart>(removeFromCart);
    on<RemoveAllFromCart>(removeAllFromCart);
    on<IncrementCartItem>(incrementCartItem);
    on<DecrementCartItem>(decrementCartItem);
    on<GetTotalPrice>(getTotalPrice);
    on<IsProductInCart>(isProductInCart);
  }

  void getCartItems(GetCartItems event, Emitter<CartState> emit) async {
    try {
      final cartItems = await cartRepository.getCartItems();
      final totalPrice = await cartRepository.getTotalPrice(couponCode: event.couponCode);
      emit(
        CartLoaded(
          cartItems: cartItems,
          totalPrice: totalPrice,
          couponCode: event.couponCode,
        ),
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void addToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await cartRepository.addToCart(event.productId, event.quantity);
      promoCode = '';
      emit(const CartUpdated(message: 'Product Added to cart'));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void updateCartItem(UpdateCartItem event, Emitter<CartState> emit) async {
    try {
      await cartRepository.updateCartItem(event.itemId, event.quantity);
      emit(const CartUpdated());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void removeFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    try {
      final cartItems = await cartRepository.removeFromCart(event.itemId);
      final totalPrice = await cartRepository.getTotalPrice(couponCode: promoCode);
      emit(
        CartLoaded(
          cartItems: cartItems,
          totalPrice: totalPrice,
        ),
      );
      // emit(CartUpdated());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void removeAllFromCart(RemoveAllFromCart event, Emitter<CartState> emit) async {
    try {
      final cartItems = await cartRepository.removeAllFromCart();
      final totalPrice = await cartRepository.getTotalPrice(couponCode: promoCode);
      emit(
        CartLoaded(
          cartItems: cartItems,
          totalPrice: totalPrice,
        ),
      );
      // emit(CartUpdated());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void incrementCartItem(IncrementCartItem event, Emitter<CartState> emit) async {
    try {
      final cartItems = await cartRepository.incrementCartItem(event.itemId);
      final totalPrice = await cartRepository.getTotalPrice(couponCode: promoCode);
      emit(
        CartLoaded(
          cartItems: cartItems,
          totalPrice: totalPrice,
        ),
      );
      // emit(CartUpdated());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void decrementCartItem(DecrementCartItem event, Emitter<CartState> emit) async {
    try {
      final cartItems = await cartRepository.decrementCartItem(event.itemId);
      final totalPrice = await cartRepository.getTotalPrice(couponCode: promoCode);
      emit(
        CartLoaded(
          cartItems: cartItems,
          totalPrice: totalPrice,
        ),
      );
      // emit(CartUpdated());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void getTotalPrice(GetTotalPrice event, Emitter<CartState> emit) async {
    try {
      final totalPrice = await cartRepository.getTotalPrice(couponCode: promoCode);
      emit(CartTotalPriceLoaded(totalPrice));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void isProductInCart(IsProductInCart event, Emitter<CartState> emit) async {
    try {
      final productInCart = await cartRepository.isProductInCart(event.productId);
      emit(ProductInCart(productInCart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}

// Cart States

/*class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(cartItems: cartManager.cartItems)) {
    on<AddItemToCart>((event, emit) {
      cartManager.addToCart(
        event.cartItem.itemName,
        event.cartItem.itemPrice,
        event.cartItem.imageUrl,
        event.cartItem.quantity,
        event.cartItem.purchaseCost,
      );
      emit(CartState(cartItems: List.of(cartManager.cartItems)));
    });

    on<RemoveItemFromCart>((event, emit) {
      cartManager.removeFromCart(event.itemName);
      emit(CartState(cartItems: List.of(cartManager.cartItems)));
    });

    on<RemoveAllFromCart>(
      (event, emit) {
        emit(const CartState(cartItems: []));
      },
    );
  }
}*/

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
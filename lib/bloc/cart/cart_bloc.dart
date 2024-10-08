import 'package:equatable/equatable.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wine_delivery_app/model/cart_item.dart';
import 'package:wine_delivery_app/utils/preferences.dart';

import '../../repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final InternetConnectionChecker internet = InternetConnectionChecker();
  bool _isOnline = false; // Track the current connection status

  CartBloc(/*this.internet*/) : super(CartInitial()) {
    on<Initial>(initial);
    on<GetCartItems>(getCartItems);
    on<AddToCart>(
      addToCart,
      transformer: (events, mapper) {
        return _throttleTransformer<AddToCart>(events, mapper);
      },
    );
    on<UpdateCartItem>(updateCartItem);
    on<RemoveFromCart>(removeFromCart);
    on<RemoveAllFromCart>(removeAllFromCart);
    on<IncrementCartItem>(
      _throttleIncrement,
      transformer: (events, mapper) {
        return _throttleTransformer<IncrementCartItem>(events, mapper);
      },
    );
    on<DecrementCartItem>(
      decrementCartItem,
      transformer: (events, mapper) {
        return _throttleTransformer<DecrementCartItem>(events, mapper);
      },
    );
    on<GetTotalPrice>(getTotalPrice);
    on<IsProductInCart>(isProductInCart);

    // Listen for connectivity changes
    internet.onConnectedToInternet.listen((isConnected) {
      if (isConnected && !_isOnline) {
        // Only trigger when going from offline to online
        _isOnline = true;
        add(Initial());
      } else if (!isConnected) {
        _isOnline = false; // Update the status when disconnected
      }
    });
  }

  void _throttleIncrement(IncrementCartItem event, Emitter<CartState> emit) async {
    try {
      final cartItems = await cartRepository.incrementCartItem(event.itemId);
      final totalPrice = await cartRepository.getTotalPrice(couponCode: promoCode);
      emit(CartLoaded(cartItems: cartItems, totalPrice: totalPrice));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  _throttleTransformer<T>(Stream<T> events, Stream<T> Function(T) mapper) {
    return events.debounceTime(const Duration(milliseconds: 500)).flatMap(mapper);
  }

  void initial(Initial event, Emitter<CartState> emit) {
    emit(CartInitial());
    add(const GetCartItems());
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
      final cartItems = await cartRepository.addToCart(event.productId, event.quantity);
      final totalPrice = await cartRepository.getTotalPrice(couponCode: promoCode);
      promoCode = '';
      emit(CartLoaded(cartItems: cartItems, totalPrice: totalPrice));
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
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

/*  void incrementCartItem(IncrementCartItem event, Emitter<CartState> emit) async {
    try {
      // Optimistically update the UI before the async call completes
      final currentState = state;
      if (currentState is CartLoaded) {
        final updatedCartItems = currentState.cartItems.map((item) {
          if (item.product!.id == event.itemId) {
            return item.copyWith(quantity: item.quantity! + 1);  // Optimistic quantity update
          }
          return item;
        }).toList();
        emit(CartLoaded(cartItems: updatedCartItems, totalPrice: currentState.totalPrice));
      }

      // Proceed with the actual repository call
      final cartItems = await cartRepository.incrementCartItem(event.itemId);
      final totalPrice = await cartRepository.getTotalPrice(couponCode: promoCode);
      emit(CartLoaded(cartItems: cartItems, totalPrice: totalPrice));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }*/

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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/features/cart/domain/entities/cart.dart';
import 'package:vintiora/features/cart/domain/usecases/add_to_cart.dart';
import 'package:vintiora/features/cart/domain/usecases/apply_coupon.dart';
import 'package:vintiora/features/cart/domain/usecases/decrement_cart_item.dart';
import 'package:vintiora/features/cart/domain/usecases/get_cart.dart';
import 'package:vintiora/features/cart/domain/usecases/increment_cart_item.dart';
import 'package:vintiora/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:vintiora/features/cart/domain/usecases/remove_coupon.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCart getCart;
  final AddToCart addToCart;
  final IncrementCartItem incrementCartItem;
  final DecrementCartItem decrementCartItem;
  final RemoveCartItem removeCartItem;
  final ApplyCoupon applyCoupon;
  final RemoveCoupon removeCoupon;

  CartBloc({
    required this.getCart,
    required this.addToCart,
    required this.incrementCartItem,
    required this.decrementCartItem,
    required this.removeCartItem,
    required this.applyCoupon,
    required this.removeCoupon,
  }) : super(const CartState()) {
    on<GetCartEvent>(_onGetCart);
    on<AddToCartEvent>(_onAddToCart);
    on<IncrementCartItemEvent>(_onIncrementCartItem);
    on<DecrementCartItemEvent>(_onDecrementCartItem);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<ApplyCouponEvent>(_onApplyCoupon);
    on<RemoveCouponEvent>(_onRemoveCoupon);
  }

  Future<void> _onGetCart(GetCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await getCart();
    result.fold(
      (failure) => emit(state.copyWith(
        status: CartStatus.error,
        message: failure.message,
      )),
      (cart) => emit(state.copyWith(
        status: CartStatus.success,
        cart: cart,
      )),
    );
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await addToCart(
      AddToCartParams(
        productId: event.productId,
        quantity: event.quantity,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: CartStatus.error,
        message: failure.message,
      )),
      (cart) => emit(state.copyWith(
        status: CartStatus.success,
        cart: cart,
      )),
    );
  }

  Future<void> _onIncrementCartItem(IncrementCartItemEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await incrementCartItem(CartItemParams(itemId: event.itemId));
    result.fold(
      (failure) => emit(state.copyWith(
        status: CartStatus.error,
        message: failure.message,
      )),
      (cart) => emit(state.copyWith(
        status: CartStatus.success,
        cart: cart,
      )),
    );
  }

  Future<void> _onDecrementCartItem(DecrementCartItemEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await decrementCartItem(CartItemParams(itemId: event.itemId));
    result.fold(
      (failure) => emit(state.copyWith(
        status: CartStatus.error,
        message: failure.message,
      )),
      (cart) => emit(state.copyWith(
        status: CartStatus.success,
        cart: cart,
      )),
    );
  }

  Future<void> _onRemoveCartItem(RemoveCartItemEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await removeCartItem(CartItemParams(itemId: event.itemId));
    result.fold(
      (failure) => emit(state.copyWith(
        status: CartStatus.error,
        message: failure.message,
      )),
      (success) {
        emit(state.copyWith(
          status: CartStatus.success,
          itemRemoved: true,
        ));
        // Refresh cart after item removal
        add(GetCartEvent());
      },
    );
  }

  Future<void> _onApplyCoupon(ApplyCouponEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await applyCoupon(CouponParams(couponCode: event.couponCode));
    result.fold(
      (failure) => emit(state.copyWith(
        status: CartStatus.error,
        message: failure.message,
      )),
      (cart) => emit(state.copyWith(
        status: CartStatus.success,
        cart: cart,
      )),
    );
  }

  Future<void> _onRemoveCoupon(RemoveCouponEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await removeCoupon();
    result.fold(
      (failure) => emit(state.copyWith(
        status: CartStatus.error,
        message: failure.message,
      )),
      (cart) => emit(state.copyWith(
        status: CartStatus.success,
        cart: cart,
      )),
    );
  }
}

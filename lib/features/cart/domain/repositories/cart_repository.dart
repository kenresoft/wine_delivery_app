import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/cart/domain/entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();

  Future<Either<Failure, Cart>> addToCart(String productId, int quantity);

  Future<Either<Failure, Cart>> incrementCartItem(String itemId);

  Future<Either<Failure, Cart>> decrementCartItem(String itemId);

  Future<Either<Failure, bool>> removeCartItem(String itemId);

  Future<Either<Failure, Cart>> applyCoupon(String couponCode);

  Future<Either<Failure, Cart>> removeCoupon();
}

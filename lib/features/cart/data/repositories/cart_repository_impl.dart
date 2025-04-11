import 'package:dartz/dartz.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:vintiora/features/cart/domain/entities/cart.dart';
import 'package:vintiora/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final InternetConnectionChecker connectionChecker;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, Cart>> getCart() async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final cartResult = await remoteDataSource.getCart();
        return cartResult.fold(
          (failure) => Left(failure),
          (cartModel) => Right(cartModel),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Cart>> addToCart(String productId, int quantity) async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.addToCart(productId, quantity);
        return result.fold(
          (failure) => Left(failure),
          (cartModel) => Right(cartModel),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Cart>> incrementCartItem(String itemId) async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.incrementCartItem(itemId);
        return result.fold(
          (failure) => Left(failure),
          (cartModel) => Right(cartModel),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Cart>> decrementCartItem(String itemId) async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.decrementCartItem(itemId);
        return result.fold(
          (failure) => Left(failure),
          (cartModel) => Right(cartModel),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> removeCartItem(String itemId) async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.removeCartItem(itemId);
        return result;
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Cart>> applyCoupon(String couponCode) async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.applyCoupon(couponCode);
        return result.fold(
          (failure) => Left(failure),
          (cartModel) => Right(cartModel),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeCoupon() async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.removeCoupon();
        return result.fold(
          (failure) => Left(failure),
          (cartModel) => Right(cartModel),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}

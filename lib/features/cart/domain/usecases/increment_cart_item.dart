import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/cart/domain/entities/cart.dart';
import 'package:vintiora/features/cart/domain/repositories/cart_repository.dart';

class IncrementCartItem {
  final CartRepository repository;

  IncrementCartItem(this.repository);

  Future<Either<Failure, Cart>> call(CartItemParams params) async {
    return await repository.incrementCartItem(params.itemId);
  }
}

class CartItemParams extends Equatable {
  final String itemId;

  const CartItemParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

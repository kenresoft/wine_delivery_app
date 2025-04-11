import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/cart/domain/entities/cart.dart';
import 'package:vintiora/features/cart/domain/repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<Either<Failure, Cart>> call(AddToCartParams params) async {
    return await repository.addToCart(params.productId, params.quantity);
  }
}

class AddToCartParams extends Equatable {
  final String productId;
  final int quantity;

  const AddToCartParams({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

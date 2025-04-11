import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/cart/domain/entities/cart.dart';
import 'package:vintiora/features/cart/domain/repositories/cart_repository.dart';
import 'package:vintiora/features/cart/domain/usecases/increment_cart_item.dart';

class DecrementCartItem {
  final CartRepository repository;

  DecrementCartItem(this.repository);

  Future<Either<Failure, Cart>> call(CartItemParams params) async {
    return await repository.decrementCartItem(params.itemId);
  }
}

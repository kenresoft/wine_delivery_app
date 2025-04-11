import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/cart/domain/repositories/cart_repository.dart';
import 'package:vintiora/features/cart/domain/usecases/increment_cart_item.dart';

class RemoveCartItem {
  final CartRepository repository;

  RemoveCartItem(this.repository);

  Future<Either<Failure, bool>> call(CartItemParams params) async {
    return await repository.removeCartItem(params.itemId);
  }
}

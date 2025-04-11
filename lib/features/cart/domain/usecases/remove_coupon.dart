import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/cart/domain/entities/cart.dart';
import 'package:vintiora/features/cart/domain/repositories/cart_repository.dart';

class RemoveCoupon {
  final CartRepository repository;

  RemoveCoupon(this.repository);

  Future<Either<Failure, Cart>> call() async {
    return await repository.removeCoupon();
  }
}

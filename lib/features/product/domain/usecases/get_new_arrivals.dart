import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/domain/repositories/product_repository.dart';

class GetNewArrivals {
  final ProductRepository repository;

  GetNewArrivals(this.repository);

  Future<Either<Failure, List<Product>>> call() {
    return repository.getNewArrivals();
  }
}

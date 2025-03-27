import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/domain/repositories/product_repository.dart';

class GetProductById {
  final ProductRepository repository;

  GetProductById(this.repository);

  Future<Either<Failure, Product>> call(String id) async {
    return await repository.getProductById(id);
  }
}


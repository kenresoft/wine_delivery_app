import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/domain/repositories/product_repository.dart';

class GetProductsByIds {
  final ProductRepository repository;

  GetProductsByIds(this.repository);

  Future<Either<Failure, List<Product>>> call(List<String> ids) async {
    return await repository.getProductsByIds(ids);
  }
}

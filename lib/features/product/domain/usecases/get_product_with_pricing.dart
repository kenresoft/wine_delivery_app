import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/product/domain/entities/product_pricing.dart';
import 'package:vintiora/features/product/domain/repositories/product_repository.dart';

class GetProductWithPricing {
  final ProductRepository repository;

  GetProductWithPricing(this.repository);

  Future<Either<Failure, ProductWithPricing>> call(String productId) async {
    return await repository.getProductWithPricing(productId);
  }
}

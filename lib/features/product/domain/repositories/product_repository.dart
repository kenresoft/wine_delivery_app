import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/domain/entities/product_pricing.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getAllProducts();

  Future<Either<Failure, Product>> getProductById(String id);

  Future<Either<Failure, List<Product>>> getProductsByIds(List<String> ids);

  Future<Either<Failure, List<Product>>> getNewArrivals();

  Future<Either<Failure, List<Product>>> getPopularProducts(int days, int limit);

  Future<Either<Failure, ProductWithPricing>> getProductWithPricing(String productId);
}

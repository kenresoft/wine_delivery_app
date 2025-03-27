import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/domain/repositories/product_repository.dart';

class GetPopularProducts {
  final ProductRepository repository;

  GetPopularProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(int days, int limit) async {
    return await repository.getPopularProducts(days: days, limit: limit);
  }
}

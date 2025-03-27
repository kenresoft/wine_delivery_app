import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/product/data/datasources/product_remote_data_source.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    final result = await remoteDataSource.getAllProducts();
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models),
    );
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    final result = await remoteDataSource.getProductById(id);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model),
    );
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByIds(List<String> ids) async {
    final result = await remoteDataSource.getProductsByIds(ids);
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models),
    );
  }

  @override
  Future<Either<Failure, List<Product>>> getNewArrivals() async {
    final result = await remoteDataSource.getNewArrivals();
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models),
    );
  }

  @override
  Future<Either<Failure, List<Product>>> getPopularProducts({required int days, required int limit}) async {
    final result = await remoteDataSource.getPopularProducts(days: days, limit: limit);
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models),
    );
  }
}

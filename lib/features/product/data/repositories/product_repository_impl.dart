import 'package:dartz/dartz.dart';
import 'package:extensionresoft/extensionresoft.dart' show InternetConnectionChecker;
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/product/data/datasources/product_remote_data_source.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/domain/entities/product_pricing.dart';
import 'package:vintiora/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final InternetConnectionChecker connectionChecker;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.getAllProducts();
        return result;
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.getProductById(id);
        return result;
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByIds(List<String> ids) async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.getProductsByIds(ids);
        return result;
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getNewArrivals() async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.getNewArrivals();
        return result;
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getPopularProducts(int days, int limit) async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.getPopularProducts(days: days, limit: limit);
        return result;
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ProductWithPricing>> getProductWithPricing(String productId) async {
    if (await connectionChecker.isInternetConnected) {
      try {
        final result = await remoteDataSource.getProductWithPricing(productId);
        return result;
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}

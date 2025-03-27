import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/product/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<Either<Failure, List<ProductModel>>> getAllProducts();

  Future<Either<Failure, ProductModel>> getProductById(String id);

  Future<Either<Failure, List<ProductModel>>> getProductsByIds(List<String> ids);

  Future<Either<Failure, List<ProductModel>>> getNewArrivals();

  Future<Either<Failure, List<ProductModel>>> getPopularProducts({required int days, required int limit});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final IApiService _apiService;

  ProductRemoteDataSourceImpl({required IApiService apiService}) : _apiService = apiService;

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    return await _apiService.request<List<ProductModel>>(
      endpoint: ApiConstants.products,
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true && data.containsKey('products')) {
          final List<dynamic> productsList = data['products'];
          return productsList.map((product) => ProductModel.fromJson(product)).toList();
        }
        throw ServerFailure('Failed to fetch products.');
      },
    );
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(String id) async {
    return await _apiService.request<ProductModel>(
      endpoint: '${ApiConstants.products}/$id',
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true && data.containsKey('product')) {
          return ProductModel.fromJson(data['product']);
        }
        throw ServerFailure('Failed to fetch product details.');
      },
    );
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByIds(List<String> ids) async {
    return await _apiService.request<List<ProductModel>>(
      endpoint: '${ApiConstants.products}/ids/${ids.join(',')}',
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true && data.containsKey('products')) {
          final List<dynamic> productsList = data['products'];
          return productsList.map((product) => ProductModel.fromJson(product)).toList();
        }
        throw ServerFailure('Failed to fetch products by IDs.');
      },
    );
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getNewArrivals() async {
    return await _apiService.request<List<ProductModel>>(
      endpoint: '${ApiConstants.products}/listings/new-arrivals',
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true && data.containsKey('products')) {
          final List<dynamic> productsList = data['products'];
          return productsList.map((product) => ProductModel.fromJson(product)).toList();
        }
        throw ServerFailure('Failed to fetch new arrivals.');
      },
    );
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getPopularProducts({required int days, required int limit}) async {
    return await _apiService.request<List<ProductModel>>(
      endpoint: '${ApiConstants.products}/listings/popular?days=$days&limit=$limit',
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true && data.containsKey('products')) {
          final List<dynamic> productsList = data['products'];
          return productsList.map((product) => ProductModel.fromJson(product)).toList();
        }
        throw ServerFailure('Failed to fetch popular products.');
      },
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/flash_sale/data/models/flash_sale_model.dart';

abstract class FlashSaleRemoteDataSource {
  /// Fetches flash sale products
  /// Throws [ServerFailure] for server errors
  Future<Either<Failure, List<FlashSaleProductModel>>> getFlashSaleProducts();

  /// Fetches active flash sales
  /// Throws [ServerFailure] for server errors
  Future<Either<Failure, List<FlashSaleModel>>> getActiveFlashSales();

  /// Fetches details for a specific flash sale
  /// Throws [ServerFailure] for server errors
  Future<Either<Failure, FlashSaleModel>> getFlashSaleDetails(String id);
}

class FlashSaleRemoteDataSourceImpl implements FlashSaleRemoteDataSource {
  final IApiService _apiService;

  FlashSaleRemoteDataSourceImpl({required IApiService apiService}) : _apiService = apiService;

  @override
  Future<Either<Failure, List<FlashSaleProductModel>>> getFlashSaleProducts() async {
    return await _apiService.request(
      endpoint: '${ApiConstants.flashSales}/products',
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true && data.containsKey('flashSaleProducts')) {
          final List<dynamic> productList = data['flashSaleProducts'];
          return productList.map((productJson) => FlashSaleProductModel.fromJson(productJson)).toList();
        } else {
          throw ServerFailure('Failed to load flash sale products');
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<FlashSaleModel>>> getActiveFlashSales() async {
    return await _apiService.request(
      endpoint: '${ApiConstants.flashSales}/active',
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true && data.containsKey('flashSales')) {
          final List<dynamic> flashSaleList = data['flashSales'];
          return flashSaleList.map((flashSaleJson) => FlashSaleModel.fromJson(flashSaleJson)).toList();
        }
        throw ServerFailure('Failed to load active flash sales');
      },
    );
  }

  @override
  Future<Either<Failure, FlashSaleModel>> getFlashSaleDetails(String id) async {
    return await _apiService.request(
      endpoint: '${ApiConstants.flashSales}/$id',
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true && data.containsKey('flashSale')) {
          final Map<String, dynamic> flashSaleJson = data['flashSale'];
          try {
            return FlashSaleModel.fromJson(flashSaleJson);
          } catch (e) {
            logger.e(e);
            rethrow;
          }
        } else {
          throw ServerFailure('Failed to load flash sale details');
        }
      },
    );
  }
}

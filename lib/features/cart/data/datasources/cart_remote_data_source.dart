import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/cart/data/models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<Either<Failure, CartModel>> getCart();

  Future<Either<Failure, CartModel>> addToCart(String productId, int quantity);

  Future<Either<Failure, CartModel>> incrementCartItem(String itemId);

  Future<Either<Failure, CartModel>> decrementCartItem(String itemId);

  Future<Either<Failure, bool>> removeCartItem(String itemId);

  Future<Either<Failure, CartModel>> applyCoupon(String couponCode);

  Future<Either<Failure, CartModel>> removeCoupon();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final IApiService _apiService;

  CartRemoteDataSourceImpl({required IApiService apiService}) : _apiService = apiService;

  @override
  Future<Either<Failure, CartModel>> getCart() async {
    return await _apiService.request<CartModel>(
      endpoint: ApiConstants.cart,
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true) {
          return CartModel.fromJson(data['cart']);
        }
        throw Exception('Failed to retrieve cart data.');
      },
    );
  }

  @override
  Future<Either<Failure, CartModel>> addToCart(String productId, int quantity) async {
    return await _apiService.request<CartModel>(
      endpoint: ApiConstants.addToCart,
      method: RequestMethod.post,
      data: {
        'productId': productId,
        'quantity': quantity,
      },
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true) {
          return CartModel.fromJson(data['cart']);
        }
        throw Exception('Failed to add item to cart.');
      },
    );
  }

  @override
  Future<Either<Failure, CartModel>> incrementCartItem(String itemId) async {
    return await _apiService.request<CartModel>(
      endpoint: '${ApiConstants.incrementCartItem}$itemId',
      method: RequestMethod.put,
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true) {
          return CartModel.fromJson(data['cart']);
        }
        throw Exception('Failed to increment cart item.');
      },
    );
  }

  @override
  Future<Either<Failure, CartModel>> decrementCartItem(String itemId) async {
    return await _apiService.request<CartModel>(
      endpoint: '${ApiConstants.decrementCartItem}$itemId',
      method: RequestMethod.put,
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true) {
          return CartModel.fromJson(data['cart']);
        }
        throw Exception('Failed to decrement cart item.');
      },
    );
  }

  @override
  Future<Either<Failure, bool>> removeCartItem(String itemId) async {
    return await _apiService.request<bool>(
      endpoint: '${ApiConstants.removeCartItem}/$itemId',
      method: RequestMethod.delete,
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true) {
          return true;
        }
        throw Exception('Failed to remove cart item.');
      },
    );
  }

  @override
  Future<Either<Failure, CartModel>> applyCoupon(String couponCode) async {
    return await _apiService.request<CartModel>(
      endpoint: ApiConstants.applyCoupon,
      method: RequestMethod.post,
      data: {
        'couponCode': couponCode,
      },
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true) {
          return CartModel.fromJson(data['cart']);
        }
        throw Exception('Failed to apply coupon code.');
      },
    );
  }

  @override
  Future<Either<Failure, CartModel>> removeCoupon() async {
    return await _apiService.request<CartModel>(
      endpoint: ApiConstants.removeCoupon,
      method: RequestMethod.delete,
      parser: (data) {
        if (data is Map<String, dynamic> && data['success'] == true) {
          return CartModel.fromJson(data['cart']);
        }
        throw Exception('Failed to remove coupon code.');
      },
    );
  }
}

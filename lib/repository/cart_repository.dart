import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/model/cart_item.dart';
import 'package:wine_delivery_app/repository/auth_repository.dart';
import 'package:wine_delivery_app/repository/product_repository.dart';
import 'package:wine_delivery_app/utils/constants.dart';

import '../model/cart.dart';
import '../utils/enums.dart';
import '../utils/utils.dart';
import 'cache_repository.dart';

class CartRepository {
  CartRepository._();

  static final CartRepository _instance = CartRepository._();

  static CartRepository getInstance() {
    return _instance;
  }

  static const String _baseUrl = '${Constants.baseUrl}/api/cart';

  Future<List<CartItem>> getCartItems() async {
    const cacheKey = 'getCartItems';

    return decide(cacheKey: cacheKey, endpoint: _baseUrl, function: _fetchCartItems);

    /*if (!cacheRepository.hasCache(cacheKey)) {
      final response = await Utils.makeRequest(_baseUrl);

      if (response.statusCode == 200) {
        await cacheRepository.cache(cacheKey, response.body);
      } else {
        await cacheRepository.cache(cacheKey, null); // Or handle error
        Utils.handleError(response);
      }
    }

    final cachedData = cacheRepository.getCache(cacheKey);
    if (cachedData != null) {
      return _fetchCartItems(cachedData);
    }

    // No cache or invalid cache, fetch from API
    final response = await Utils.makeRequest('$_baseUrl/user');
    if (response.statusCode == 200) {
      await cacheRepository.cache(cacheKey, response.body);
      return _fetchCartItems(response.body);
    } else {
      throw Utils.handleError(response);
    }*/

    /*try {
      final response = await Utils.makeRequest(_baseUrl);

      return await parseCartResponse(response);
    } catch (e) {
      if (e is SocketException) {
        throw 'Failed to fetch cart items. Please check your internet connection and try again.';
      }
      throw 'Failed to fetch cart items: ${e.toString()}';
    }*/
  }

  Future<List<CartItem>> _fetchCartItems(data) async {
    print(data);
    final cartItemsJson = data['cart']['items'] as List<dynamic>;

    // Fetch all products in parallel
    List<CartItem> cartItems = await Future.wait(cartItemsJson.map((itemJson) async {
      final cartItem = Cart.fromJson(itemJson);
      final product = await productRepository.getProductById(cartItem.product!);

      return CartItem(id: cartItem.id, quantity: cartItem.quantity, product: product);
    }).toList());
    print(cartItems);
    return cartItems;
  }

  Future<List<CartItem>> addToCart(String productId, int quantity) async {
    final token = await authRepository.getAccessToken();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'productId': productId, 'quantity': quantity}),
      );

      return await parseCartResponse(response);

      /*if (response.statusCode != 200) {
        throw 'Error adding to cart: ${response.statusCode} - ${response.reasonPhrase}';
      }*/
    } catch (e) {
      throw 'Failed to add to cart: ${e.toString()}';
    }
  }

  Future<void> updateCartItem(String itemId, int quantity) async {
    final token = await authRepository.getAccessToken();

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$itemId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'quantity': quantity}),
      );

      if (response.statusCode != 200) {
        throw 'Error updating cart item: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      throw 'Failed to update cart item: ${e.toString()}';
    }
  }

  Future<List<CartItem>> removeFromCart(String itemId) async {
    final token = await authRepository.getAccessToken();

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$itemId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return await parseCartResponse(response);

      /*if (response.statusCode != 200) {
        throw 'Error removing from cart: ${response.statusCode} - ${response.reasonPhrase}';
      }*/
    } catch (e) {
      throw 'Failed to remove from cart: ${e.toString()}';
    }
  }

  Future<List<CartItem>> removeAllFromCart() async {
    final token = await authRepository.getAccessToken();

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return await parseCartResponse(response);

      /*if (response.statusCode != 200) {
        throw 'Error removing from cart: ${response.statusCode} - ${response.reasonPhrase}';
      }*/
    } catch (e) {
      throw 'Failed to remove from cart: ${e.toString()}';
    }
  }

  Future<List<CartItem>> incrementCartItem(String itemId) async {
    try {
      final response = await Utils.makeRequest('$_baseUrl/increment/$itemId', method: RequestMethod.put);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<CartItem> cartItems = await _fetchCartItems(data);

        return cartItems;
      } else {
        throw Exception('Error fetching cart items: ${response.statusCode} - ${response.reasonPhrase}');
      }

      /*if (response.statusCode != 200) {
        throw 'Error incrementing cart item: ${response.statusCode} - ${response.reasonPhrase}';
      }*/
    } catch (e) {
      throw 'Failed to increment cart item: ${e.toString()}';
    }
  }

  Future<List<CartItem>> decrementCartItem(String itemId) async {
    final token = await authRepository.getAccessToken();

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/decrement/$itemId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return await parseCartResponse(response);

      /*if (response.statusCode != 200) {
        throw 'Error decrementing cart item: ${response.statusCode} - ${response.reasonPhrase}';
      }*/
    } catch (e) {
      throw 'Failed to decrement cart item: ${e.toString()}';
    }
  }

  Future<double> getTotalPrice({String? couponCode}) async {
    final token = await authRepository.getAccessToken();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/price'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'couponCode': couponCode}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return double.parse(data['totalPrice'].toString());
      } else {
        throw 'Error fetching total price: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      throw 'Failed to fetch total price: ${e.toString()}';
    }
  }

  Future<bool> isProductInCart(String productId) async {
    final token = await authRepository.getAccessToken();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/isProductInCart/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['productInCart'];
      } else {
        throw 'Error checking if product is in cart: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      throw 'Failed to check if product is in cart: ${e.toString()}';
    }
  }

  Future<List<CartItem>> parseCartResponse(http.Response response) async {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<CartItem> cartItems = await _fetchCartItems(data);

      return cartItems;
    } else {
      throw Exception('Error fetching cart items: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}

CartRepository cartRepository = CartRepository.getInstance();
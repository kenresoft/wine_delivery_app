import 'dart:convert';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/model/cart_item.dart';
import 'package:wine_delivery_app/repository/auth_repository.dart';
import 'package:wine_delivery_app/repository/decision_repository.dart';
import 'package:wine_delivery_app/repository/product_repository.dart';
import 'package:wine_delivery_app/utils/constants.dart';

import '../model/cart.dart';
import '../utils/enums.dart';
import '../utils/logger.dart';
import '../utils/utils.dart';

class CartRepository {
  const CartRepository._();

  static const CartRepository _instance = CartRepository._();

  static CartRepository getInstance() {
    return _instance;
  }

  static final String _baseUrl = '${Constants.baseUrl}/api/cart';

  Future<List<CartItem>> getCartItems() async {
    const cacheKey = 'getCartItems';

    return DecisionRepository().decide<List<CartItem>>(
      cacheKey: cacheKey,
      endpoint: _baseUrl,
      onSuccess: (data) async {
        final cartItemsJson = data['cart']['items'] as List<dynamic>;

        // Fetch all products in parallel
        List<CartItem> cartItems = await Future.wait(cartItemsJson.map((itemJson) async {
          final cartItem = Cart.fromJson(itemJson);
          final product = await productRepository.getProductById(cartItem.product!);

          return CartItem(id: cartItem.id, quantity: cartItem.quantity, product: product);
        }).toList());
        // logger.i('Data fetched from cache');
        logToDevice('Data fetched from cache');

        logToDevice(cartItems.toString(), 'cart.log');
        return cartItems;
      },
      onError: (error) async {
        logger.e('ERROR: ${error.toString()}');
        return [];
      },
      // function: (data) => _fetchCartItems(data),
    );
  }

  Future<List<CartItem>> _fetchCartItems(data) async {
    final cartItemsJson = data['cart']['items'] as List<dynamic>;

    // Fetch all products in parallel
    List<CartItem> cartItems = await Future.wait(cartItemsJson.map((itemJson) async {
      final cartItem = Cart.fromJson(itemJson);
      final product = await productRepository.getProductById(cartItem.product!);

      return CartItem(id: cartItem.id, quantity: cartItem.quantity, product: product);
    }).toList());
    logger.i('Data fetched from cache');
    logToDevice('Data fetched from cache');

    logger.i(cartItems.toString());
    logToDevice(cartItems.toString(), 'cart.log');
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
    final hasInternetAccess = await InternetConnectionChecker().hasInternetAccess();
    if (!hasInternetAccess) {
      logger.e('No internet access');
      return getCartItems();
    }
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
    final hasInternetAccess = await InternetConnectionChecker().hasInternetAccess();
    if (!hasInternetAccess) {
      logger.e('No internet access');
      return getCartItems();
    }
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
    final hasInternetAccess = await InternetConnectionChecker().hasInternetAccess();
    if (!hasInternetAccess) {
      logger.e('No internet access');
      return getCartItems();
    }
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
    final hasInternetAccess = await InternetConnectionChecker().hasInternetAccess();
    if (!hasInternetAccess) {
      logger.e('No internet access');
      return getCartItems();
    }
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
    return DecisionRepository().decide<double>(
      cacheKey: 'getTotalPrice',
      endpoint: '$_baseUrl/price',
      requestMethod: RequestMethod.post,
      body: jsonEncode({'couponCode': couponCode}),
      onSuccess: (data) async {
        return double.parse(data['totalPrice'].toString());
      },
      onError: (error) async {
        logger.e('ERROR: ${error.toString()}');
        return 0.0;
      },
    );

    /*try {
      final response = await Utils.makeRequest(
        '$_baseUrl/price',
        method: RequestMethod.post,
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
    }*/
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
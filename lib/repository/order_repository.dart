import 'dart:convert';

// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/repository/auth_repository.dart';
import 'package:wine_delivery_app/repository/product_repository.dart';
import 'package:wine_delivery_app/utils/constants.dart';
import 'package:wine_delivery_app/utils/exceptions.dart';

import '../model/order.dart';
import '../model/order_item.dart';
import '../model/order_product_item.dart';
import '../utils/utils.dart';
import 'cache_repository.dart';

class OrderRepository {
  // Private constructor
  OrderRepository._();

  // Static private instance variable
  static final OrderRepository _instance = OrderRepository._();

  // Getter for the singleton instance
  static OrderRepository getInstance() {
    return _instance;
  }

  final String _baseUrl = '${Constants.baseUrl}/api/orders';

  // Create an order
  Future<Order> createOrder({
    required double subTotal,
    required String note,
  }) async {
    final token = await authRepository.getAccessToken();

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'subTotal': subTotal,
          'note': note,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data['order']);
      } else {
        throw Utils.handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to create order: ${e.toString()}');
    }
  }

  Future<bool> makePurchase({
    required String orderId,
    required String description,
    required String currency,
    required String paymentMethod,
  }) async {
    final token = await authRepository.getAccessToken();

    try {
      final url = Uri.parse('$_baseUrl/$orderId/purchase');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'description': description,
          'currency': currency,
          'paymentMethod': paymentMethod,
        }),
      );

      if (response.statusCode == 200) {
        /*final data = jsonDecode(response.body);
        final paymentResponse = data['paymentResponse']; // Assuming your response structure

        if (paymentResponse['success']) {
          // Payment successful, update order locally if needed
          // (But avoid sensitive details)
          final updatedOrder = Order.fromJson(data['order']);
          return updatedOrder;
        } else {
          throw Exception(paymentResponse['message']);
        }*/
        final data = jsonDecode(response.body);
        final order = Order.fromJson(data['order']);
        final paymentIntent = order.paymentDetails?.paymentIntent;
        if (paymentIntent != null && paymentIntent.isNotEmpty) {

          /*await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent,
              merchantDisplayName: "Wine Delivery",
            ),
          );

          await Stripe.instance.presentPaymentSheet();
          await Stripe.instance.confirmPaymentSheetPayment();*/

          return true;
        }
        return false;
      } else {
        throw Utils.handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to make payment: ${e.toString()}');
    }
  }

  // Get orders by user
  Future<List<Order>> getUserOrders() async {
    const cacheKey = 'userOrders';

    try {
      if (!cacheRepository.hasCache(cacheKey)) {
        final response = await Utils.makeRequest('$_baseUrl/user');

        if (response.statusCode == 200) {
          await cacheRepository.cache(cacheKey, response.body);
        } else {
          await cacheRepository.cache(cacheKey, null); // Or handle error
          Utils.handleError(response);
        }
      }

      final cachedData = cacheRepository.getCache(cacheKey);
      if (cachedData != null) {
        return _fetchOrders(jsonDecode(cachedData));
      }

      // No cache or invalid cache, fetch from API
      final response = await Utils.makeRequest('$_baseUrl/user');
      if (response.statusCode == 200) {
        await cacheRepository.cache(cacheKey, response.body);
        return _fetchOrders(jsonDecode(response.body));
      } else {
        throw Utils.handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: ${e.toString()}');
    }
  }

  List<Order> _fetchOrders(data) {
    final List<dynamic> ordersJson = data['orders'];
    final orders = ordersJson.map((json) => Order.fromJson(json)).toList();
    return orders;
  }

/*  Future<List<Order>> getUserOrders() async {
    try {
      if (!await cacheRepository.hasCache('')) {
        final response = await Utils.makeRequest('$_baseUrl/user');

        if (response.statusCode == 200) {
          await cacheRepository.cache('cachedOrders', response.body);
        } else {
          await cacheRepository.cache('cachedOrders', null);
          Utils.handleError(response);
        }
      }

      final data = jsonDecode(cacheRepository.getCache(''));
      final List<dynamic> ordersJson = data['orders'];
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: ${e.toString()}');
    }
  }*/

  // Get orders by user
  Future<List<OrderProductItem>> getUserOrderItems() async {
    final token = await authRepository.getAccessToken();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final cartItemsJson = data['orders']['items'] as List<dynamic>;

        final futures = cartItemsJson.map((itemJson) async {
          final orderItem = OrderItem.fromJson(itemJson);
          try {
            final product = await productRepository.getProductById(orderItem.productId);
            return OrderProductItem(quantity: orderItem.quantity, product: product);
          } catch (e) {
            // Handle error fetching individual product
            print('Error fetching product: ${orderItem.productId}');
            return null; // Or return a placeholder item
          }
        });

        final orderProductItems = await Future.wait(futures);
        return orderProductItems.whereType<OrderProductItem>().toList();
      } else {
        throw Utils.handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: ${e.toString()}');
    }
  }

  // Get order by ID
  Future<Order> getOrderById(String orderId) async {
    try {
      final response = await Utils.makeRequest('$_baseUrl/$orderId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data['order']); // Parse the order data
      } else {
        throw Utils.handleError(response);
      }
    } catch (e) {
      throw Utils.handleError(http.Response('', 999, reasonPhrase: '$e'));
    }
  }

  // Update order status
  Future<Order> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final token = await authRepository.getAccessToken();

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/$orderId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data['order']); // Parse the updated order data
      } else {
        throw Utils.handleError(response);
      }
    } catch (e) {
      throw UnexpectedException('Failed to update order status: ${e.toString()}');
    }
  }

  /// Handling Caching for Orders
  Future<void> cacheOrders(List<Order> orders) async {
    final orderJsonList = orders.map((order) => jsonEncode(order.toJson())).toList();
    // Save the orderJsonList using SharedPreferences or Hive
  }

  Future<List<Order>> getCachedOrders() async {
    // Retrieve and decode cached orders
    final cachedOrders = []; // From SharedPreferences or Hive
    return cachedOrders.map((orderJson) => Order.fromJson(jsonDecode(orderJson))).toList();
  }
}

final OrderRepository orderRepository = OrderRepository.getInstance();

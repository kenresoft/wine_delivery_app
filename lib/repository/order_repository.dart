import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/repository/auth_repository.dart';
import 'package:wine_delivery_app/repository/product_repository.dart';
import 'package:wine_delivery_app/utils/constants.dart';

import '../model/order/order.dart';

class OrderRepository {
  // Private constructor
  OrderRepository._();

  // Static private instance variable
  static final OrderRepository _instance = OrderRepository._();

  // Getter for the singleton instance
  static OrderRepository getInstance() {
    return _instance;
  }

  // API Base URL
  final String _baseUrl = '${Constants.baseUrl}/api/orders';

  // Create an order
  Future<Order> createOrder({
    required double subTotal,
    required String description,
    required String currency,
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
          'description': description,
          'currency': currency,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data['order']); // Parse the order data
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to create order: ${e.toString()}');
    }
  }

  // Get orders by user
  Future<List<Order>> getUserOrders() async {
    final token = authRepository.getAccessToken();

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
        final List<dynamic> ordersJson = data['orders'];

        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: ${e.toString()}');
    }
  }

  // Get orders by user
  Future<List<OrderProductItem>> getUserOrderItems() async {
    final token = authRepository.getAccessToken();

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

        // Fetch all products in parallel
        List<OrderProductItem> orderProductItem = await Future.wait(cartItemsJson.map((itemJson) async {
          final orderItem = OrderItem.fromJson(itemJson);
          final product = await productRepository.getProductById(orderItem.productId);

          return OrderProductItem(
            id: orderItem.id,
            quantity: orderItem.quantity,
            product: product,
          );
        }).toList());

        print(orderProductItem.toString());
        return orderProductItem;
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: ${e.toString()}');
    }
  }

  // Get order by ID
  Future<Order> getOrderById(String orderId) async {
    final token = authRepository.getAccessToken();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data['order']); // Parse the order data
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to fetch order: ${e.toString()}');
    }
  }

  // Update order status
  Future<Order> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final token = authRepository.getAccessToken();

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
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to update order status: ${e.toString()}');
    }
  }

  // Handle errors based on status code
  String _handleError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return 'Bad request, please check your input.';
      case 401:
        return 'Unauthorized access, please log in again.';
      case 403:
        return 'Forbidden access.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Internal server error, please try again later.';
      default:
        return 'Unexpected error: ${response.statusCode} - ${response.reasonPhrase}';
    }
  }
}

final OrderRepository orderRepository = OrderRepository.getInstance();

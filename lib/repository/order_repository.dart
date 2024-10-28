import 'dart:convert';

// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/repository/auth_repository.dart';
import 'package:wine_delivery_app/repository/product_repository.dart';

import '../model/order.dart';
import '../model/order_item.dart';
import '../model/order_product_item.dart';
import '../utils/helpers.dart';
import 'decision_repository.dart';

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
    required void Function(Order order) callback,
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
        final order = Order.fromJson(data['order']);
        callback.call(order);
        return order;
      } else {
        throw Utils.handleError(response: response);
      }
    } catch (e) {
      throw Exception('Failed to create order: ${e.toString()}');
    }
  }

  Future<void> makePurchase({
    required String orderId,
    required String description,
    required String currency,
    required String paymentMethod,
    required PurchaseCallback callback,
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
        final data = jsonDecode(response.body);
        final order = Order.fromJson(data['order']);
        final paymentIntent = order.paymentDetails?.paymentIntent;

        if (paymentIntent != null && paymentIntent.isNotEmpty) {
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent,
              merchantDisplayName: "Wine Delivery",
            ),
          );

          await Stripe.instance.presentPaymentSheet();
          await Stripe.instance.confirmPaymentSheetPayment();

          // Payment success, invoke callback with true
          callback(true);
        } else {
          // No payment intent, invoke callback with false
          callback(false, message: "Payment intent not found");
        }
      } else {
        throw Utils.handleError(response: response);
      }
    } on StripeException catch (e) {
      callback(false, message: e.error.localizedMessage);
    } catch (e) {
      callback(false, message: 'Failed to make payment: ${e.toString()}');
    }
  }

  // Get orders by user
Future<List<Order>> getUserOrders({int page = 1, int pageSize = 10}) async {
    final cacheKey = 'getUserOrders_page_$page';
    final endpoint = '$_baseUrl/user?page=$page&limit=$pageSize';

    return DecisionRepository().decide(
      cacheKey: cacheKey,
      endpoint: endpoint,
      onSuccess: (data) async {
        final List<dynamic> ordersJson = data['orders'];
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      },
      onError: (error) async {
        logger.e('ERROR: ${error.toString()}');
        return [];
      },
    );
  }

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
            logger.e('Error fetching product: ${orderItem.productId}');
            return null;
          }
        });

        final orderProductItems = await Future.wait(futures);
        return orderProductItems.whereType<OrderProductItem>().toList();
      } else {
        throw Utils.handleError(response: response);
      }
    } catch (e) {
      throw Exception('Failed to fetch order items: ${e.toString()}');
    }
  }

  // Get order by ID
  Future<Order> getOrderById(String orderId) async {
    try {
      final response = await Utils.makeRequest('$_baseUrl/$orderId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data['order']);
      } else {
        throw Utils.handleError(response: response);
      }
    } catch (e) {
      rethrow;
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
        return Order.fromJson(data['order']);
      } else {
        throw Utils.handleError(response: response);
      }
    } catch (e) {
      throw UnexpectedException('Failed to update order status: ${e.toString()}');
    }
  }
}

final OrderRepository orderRepository = OrderRepository.getInstance();

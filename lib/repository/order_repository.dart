import 'package:wine_delivery_app/utils/utils.dart';

import '../model/order.dart';
import '../model/order_item.dart';
import '../model/order_status.dart';
import 'cart_repository.dart';

class OrderRepository {
  // Private constructor
  OrderRepository._();

  // Static private instance variable
  static final OrderRepository _instance = OrderRepository._();

  // Getter for the singleton instance
  static OrderRepository getInstance() {
    return _instance;
  }

  List<Order> orders = [];

  void createOrder() {
    // Assuming orders list exists and is accessible
    Order newOrder = Order(
      orderId: '123456', // Generate a unique order ID
      orderDate: DateTime.now(),
      items: cartManager.cartItems.map((cartItem) {
        return OrderItem(
          itemName: cartItem.itemName,
          itemPrice: cartItem.itemPrice,
          quantity: cartItem.quantity,
        );
      }).toList(),
      status: OrderStatus.processing,
    );
    if (cartManager.cartItems.isNotEmpty) {
      orders.add(newOrder);
      'Order created !'.toast;
      // Clear cart after creating order
      cartManager.cartItems.clear();
    } else {
      'Cart is Empty !'.toast;
    }
    // Optionally show a confirmation message to the user
  }
}

// Usage:
// Access the singleton instance using OrderManager.getInstance()
final OrderRepository orderManager = OrderRepository.getInstance();

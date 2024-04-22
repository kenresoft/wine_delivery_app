import 'order_item.dart';
import 'order_status.dart';

class Order {
  final String orderId;
  final DateTime orderDate;
  final List<OrderItem> items; // Updated to a list of OrderItem objects
  OrderStatus status;

  Order({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.status,
  });
}


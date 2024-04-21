import 'order_status.dart';

class Order {
  final String orderId;
  final DateTime orderDate;
  final List<String> items;
  OrderStatus status;

  Order({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.status,
  });
}

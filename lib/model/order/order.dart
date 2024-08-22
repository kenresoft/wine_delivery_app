import 'package:equatable/equatable.dart';

part 'order_item.dart';

part 'order_status.dart';

class Order extends Equatable {
  final String orderId;
  final DateTime orderDate;
  final List<OrderItem> items;
  final OrderStatus status;

  const Order({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.status,
  });

  factory Order.empty() {
    return Order(
      orderId: '', // Or generate a unique ID here
      orderDate: DateTime.now(),
      items: const [],
      status: OrderStatus.pending,
    );
  }

  Order copyWith({
    String? orderId,
    DateTime? orderDate,
    List<OrderItem>? items,
    OrderStatus? status,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      orderDate: orderDate ?? this.orderDate,
      items: items ?? this.items,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [orderId, orderDate, items, status];

  @override
  bool get stringify => true; // Set stringify to true for better debugging
}

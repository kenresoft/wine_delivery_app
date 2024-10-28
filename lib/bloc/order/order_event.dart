part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrder extends OrderEvent {
  final double subTotal;
  final String note;
  final void Function(Order order) callback;

  const CreateOrder({required this.subTotal, required this.note, required this.callback});

  @override
  List<Object?> get props => [subTotal, note];
}

class GetUserOrders extends OrderEvent {}

class GetOrderById extends OrderEvent {
  final String orderId;

  const GetOrderById(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String status;

  const UpdateOrderStatus({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

class UpdateOrder extends OrderEvent {
  final Order order;

  const UpdateOrder({required this.order});

  @override
  List<Object?> get props => [order];
}

class ListenToOrderStatusUpdates extends OrderEvent {
  final String orderId;
  final String status;

  const ListenToOrderStatusUpdates({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object> get props => [orderId, status];
}

// order_event.dart additions
class SortOrders extends OrderEvent {
  final String criterion;

  const SortOrders(this.criterion);
}

class FilterOrdersByStatus extends OrderEvent {
  final OrderStatus status;

  const FilterOrdersByStatus(this.status);
}

class LoadMoreOrders extends OrderEvent {}

part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrder extends OrderEvent {
  final double subTotal;
  final String note;

  const CreateOrder({required this.subTotal, required this.note});

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
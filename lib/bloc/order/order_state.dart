part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();

  @override
  List<Object?> get props => [];
}

class OrderCreated extends OrderState {
  final Order order;

  const OrderCreated(this.order);

  @override
  List<Object?> get props => [order];
}

class OrdersLoaded extends OrderState {
  final List<Order> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

/// NEW
class OrderProductsLoaded extends OrderState {
  final List<OrderProductItem> orderItems;

  const OrderProductsLoaded(this.orderItems);

  @override
  List<Object?> get props => [orderItems];
}

class OrderLoaded extends OrderState {
  final Order order;
  final double orderProgress;

  const OrderLoaded(this.order, this.orderProgress);

  @override
  List<Object?> get props => [order];
}

class OrderStatusUpdated extends OrderState {
  final Order order;

  const OrderStatusUpdated(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}
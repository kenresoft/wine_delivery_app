part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();
}

class SaveOrderID extends OrderEvent {
  final String orderID;

  const SaveOrderID(this.orderID);

  @override
  List<Object?> get props => [orderID];
}

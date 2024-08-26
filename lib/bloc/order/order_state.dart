part of 'order_bloc.dart';

class OrderState extends Equatable {
  const OrderState(this.orderID);

  final String orderID;

  @override
  List<Object?> get props => [orderID];
}

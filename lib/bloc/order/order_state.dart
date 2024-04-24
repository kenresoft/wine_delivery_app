part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();
}

final class OrderInitial extends OrderState {
  @override
  List<Object> get props => [];
}

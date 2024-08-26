import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderState('')) {
    on<SaveOrderID>((event, emit) {
      emit(OrderState(event.orderID));
    });
  }
}

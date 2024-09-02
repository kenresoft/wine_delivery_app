import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/model/order/order.dart';
import 'package:wine_delivery_app/repository/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderInitial()) {
    on<CreateOrder>(createOrder);
    on<GetUserOrders>(getUserOrders);
    on<GetOrderById>(getOrderById);
    on<UpdateOrderStatus>(updateOrderStatus);
  }

  Future<void> createOrder(CreateOrder event, Emitter<OrderState> emit) async {
    try {
      final order = await orderRepository.createOrder(
        subTotal: event.subTotal,
        description: event.description,
        currency: event.currency,
      );
      emit(OrderCreated(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> getUserOrders(GetUserOrders event, Emitter<OrderState> emit) async {
    try {
      final orders = await orderRepository.getUserOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> getOrderById(GetOrderById event, Emitter<OrderState> emit) async {
    try {
      final order = await orderRepository.getOrderById(event.orderId);
      emit(OrderLoaded(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> updateOrderStatus(UpdateOrderStatus event, Emitter<OrderState> emit) async {
    try {
      final updatedOrder = await orderRepository.updateOrderStatus(
        orderId: event.orderId,
        status: event.status,
      );
      emit(OrderStatusUpdated(updatedOrder));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
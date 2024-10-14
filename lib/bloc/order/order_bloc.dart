import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/model/order.dart';
import 'package:wine_delivery_app/repository/order_repository.dart';

import '../../model/order_product_item.dart';
import '../../repository/socket_repository.dart';
import '../../utils/enums.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderInitial()) {
    on<CreateOrder>(_createOrder);
    // on<GetUserOrders>(getUserOrders);
    on<GetUserOrders>(_getUserProductOrders);
    on<UpdateOrderStatus>(_updateOrderStatus);
    on<ListenToOrderStatusUpdates>(_listenToOrderStatusUpdates);

    on<UpdateOrder>(_onOrderUpdated); /// I mapped the event to the state here

    // Automatically subscribe to order updates when fetching order details
    on<GetOrderById>((event, emit) async {
      await _getOrderById(event, emit);
      /// This is where i called the event that connects and listens to my stream.
      /// It has no state which it is mapped to. It rather adds (calls) another event --> UpdateOrder.
      add(ListenToOrderStatusUpdates(orderId: event.orderId, status: ''));
    });
  }

  Future<void> _createOrder(CreateOrder event, Emitter<OrderState> emit) async {
    try {
      final order = await orderRepository.createOrder(
        subTotal: event.subTotal,
        note: event.note,
        callback: event.callback,
      );
      emit(OrderCreated(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _getUserOrders(GetUserOrders event, Emitter<OrderState> emit) async {
    try {
      final orders = await orderRepository.getUserOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _getUserProductOrders(GetUserOrders event, Emitter<OrderState> emit) async {
    try {
      final orderItems = await orderRepository.getUserOrderItems();
      emit(OrderProductsLoaded(orderItems));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
    // add(const OrderStatusUpdatedEvent(orderId: '', status: ''));
  }

  Future<void> _getOrderById(GetOrderById event, Emitter<OrderState> emit) async {
    try {
      final order = await orderRepository.getOrderById(event.orderId);
      emit(OrderLoaded(order, _calculateProgress(order.status)));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _updateOrderStatus(UpdateOrderStatus event, Emitter<OrderState> emit) async {
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

  Future<void> _listenToOrderStatusUpdates(ListenToOrderStatusUpdates event, Emitter<OrderState> emit) async {
    await socketRepository.connectSocket();

    socketRepository.socket?.on('orderUpdated', (data) {
      final order = Order.fromJson(data['order']);
      if (event.orderId == order.id) {
        add(UpdateOrder(order: order)); /// I called the update event
      }
    });
  }

  void _onOrderUpdated(UpdateOrder event, Emitter<OrderState> emit) {
    emit(OrderLoaded(event.order, _calculateProgress(event.order.status))); /// I emitted the update state here
  }

  double _calculateProgress(OrderStatus status) {
    switch (status) {
      case OrderStatus.draft:
        return 0.0;
      case OrderStatus.pending:
        return 0.2;
      case OrderStatus.processing:
        return 0.4;
      case OrderStatus.packaging:
        return 0.6;
      case OrderStatus.shipping:
        return 0.8;
      case OrderStatus.delivered:
        return 1.0;
      case OrderStatus.cancelled:
        return 1.0; // Full progress, but cancelled state
      default:
        return 0.0;
    }
  }
}
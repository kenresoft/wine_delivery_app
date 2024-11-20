import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/model/order.dart';
import 'package:vintiora/repository/order_repository.dart';

import '../../model/order_product_item.dart';
import '../../repository/socket_repository.dart';
import '../../utils/enums.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  // Pagination parameters
  int _currentPage = 1;
  final int _pageSize = 8;
  bool hasMoreOrders = true;

  // Stores all orders across pages
  final Set<Order> _allOrders = {};
  List<Order> _displayedOrders = [];

  OrderStatus? _currentFilterStatus;
  String? _currentSortCriterion;

  OrderBloc() : super(const OrderInitial()) {
    on<CreateOrder>(_createOrder);
    on<GetUserOrders>(_getUserOrders);
    // on<GetUserOrders>(_getUserProductOrders);
    on<LoadMoreOrders>(_loadMoreOrders);
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

    // Event handlers for sorting and filtering
    on<SortOrders>(_onSortOrders);
    on<FilterOrdersByStatus>(_onFilterOrdersByStatus);
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

  Future<void> _getOrderById(GetOrderById event, Emitter<OrderState> emit) async {
    try {
      final order = await orderRepository.getOrderById(event.orderId);
      emit(OrderLoaded(order, _calculateProgress(order.status!)));
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
    emit(OrderLoaded(event.order, _calculateProgress(event.order.status!))); /// I emitted the update state here
  }

  Future<void> _getUserOrders(GetUserOrders event, Emitter<OrderState> emit) async {
    _currentPage = 1; // Reset page
    hasMoreOrders = true; // Reset load status
    _allOrders.clear();
    _displayedOrders.clear();
    await _loadOrders(emit);
  }

  Future<void> _loadMoreOrders(LoadMoreOrders event, Emitter<OrderState> emit) async {
    if (hasMoreOrders) {
      _currentPage += 1;
      await _loadOrders(emit);
    }
  }

  Future<void> _loadOrders(Emitter<OrderState> emit) async {
    try {
      final orders = await orderRepository.getUserOrders(
        page: _currentPage,
        pageSize: _pageSize,
      );

      // Check if there are more pages to load
      if (orders.length < _pageSize) hasMoreOrders = false;

      // Append new orders to the cumulative list
      _allOrders.addAll(orders);

      _displayedOrders = _applySortAndFilter(_allOrders);

      if (_displayedOrders.isNotEmpty) {
        emit(OrdersLoaded(List.from(_displayedOrders)));
      } else {
        emit(OrderError('You don\'t have any order yet!'));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  // Helper methods for sorting and filtering
  List<Order> _applySortAndFilter(Set<Order> orders) {
    var filteredOrders = orders.toList();

    if (_currentFilterStatus != null) {
      filteredOrders = _filterOrders(filteredOrders, _currentFilterStatus!);
    }

    if (_currentSortCriterion != null) {
      filteredOrders = _sortOrdersByCriterion(filteredOrders, _currentSortCriterion!);
    }

    return filteredOrders;
  }

  void _onSortOrders(SortOrders event, Emitter<OrderState> emit) {
    _currentSortCriterion = event.criterion;
    _displayedOrders = _applySortAndFilter(_allOrders);
    emit(OrdersLoaded(List.from(_displayedOrders)));
  }

  void _onFilterOrdersByStatus(FilterOrdersByStatus event, Emitter<OrderState> emit) {
    _currentFilterStatus = event.status;
    _displayedOrders = _applySortAndFilter(_allOrders);
    emit(OrdersLoaded(List.from(_displayedOrders)));
  }

// Method to filter orders based on status
  List<Order> _filterOrders(List<Order> orders, OrderStatus status) {
    return orders.where((order) => order.status == status).toList();
  }

// Method to sort orders based on criterion
  List<Order> _sortOrdersByCriterion(List<Order> orders, String criterion) {
    switch (criterion) {
      case 'date':
        orders.sort((a, b) => b.createdAt!.compareTo(a.createdAt!)); // Newest first
        break;
      case 'price':
        orders.sort((a, b) => b.subTotal!.compareTo(a.subTotal!)); // Highest price first
        break;
      // Add more criteria as needed
      default:
        break;
    }
    return orders;
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
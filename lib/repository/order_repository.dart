import 'package:wine_delivery_app/utils/utils.dart';

import '../model/order/order.dart';
import 'cart_repository.dart';

class OrderRepository {
  // Private constructor
  OrderRepository._();

  // Static private instance variable
  static final OrderRepository _instance = OrderRepository._();

  // Getter for the singleton instance
  static OrderRepository getInstance() {
    return _instance;
  }

  List<Order> orders = [];

  int _orderIdCounter = 1000;

  String _generateOrderId() {
    String newOrderId = '';
    bool isUnique = false;
    while (!isUnique) {
      newOrderId = 'ORD${_orderIdCounter++}';
      isUnique = !orders.any((order) => order.orderId == newOrderId);
    }
    return newOrderId;
  }

  void createOrder() {
    if (cartManager.cartItems.isNotEmpty) {
      Order newOrder = Order(
        orderId: _generateOrderId(), // Generate ID only if cart has items
        orderDate: DateTime.now(),
        items: cartManager.cartItems.map((cartItem) {
          return OrderItem(
            itemName: cartItem.itemName,
            itemPrice: cartItem.itemPrice,
            quantity: cartItem.quantity,
            imageUrl: cartItem.imageUrl,
          );
        }).toList(),
        status: OrderStatus.processing,
      );
      orders.add(newOrder);
      'Order created !'.toast;
      cartManager.cartItems.clear();
    } else {
      'Cart is Empty !'.toast;
    }
  }

  void deleteOrder(String orderId) {
    Order? orderToDelete = orders.firstWhere((order) => order.orderId == orderId, orElse: () => Order.empty());
    if (orderToDelete.status != OrderStatus.pending) {
      orders.remove(orderToDelete);
      'Order deleted !'.toast;
    } else {
      'Order not found !'.toast;
    }
  }

  void deleteAllOrders() {
    orders.clear();
    'All orders deleted !'.toast;
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    Order? orderToUpdate = orders.firstWhere((order) => order.orderId == orderId, orElse: () => Order.empty());
    if (orderToUpdate.status != OrderStatus.pending) {
      Order updatedOrder = orderToUpdate.copyWith(status: newStatus);
      orders[orders.indexWhere((order) => order.orderId == orderId)] = updatedOrder;
      'Order status updated !'.toast;
    } else {
      'Order not found !'.toast;
    }
  }

  Order getOrderById(String orderId) {
    Order? order = orders.firstWhere((order) => order.orderId == orderId, orElse: () => Order.empty());
    if (order.status != OrderStatus.pending) {
      return order;
    } else {
      return Order.empty();
    }
  }

  List<OrderItem> getOrderItems(String orderId) {
    Order? order = orders.firstWhere((order) => order.orderId == orderId, orElse: () => Order.empty());
    if (order.status != OrderStatus.pending) {
      return order.items;
    } else {
      return [];
    }
  }

  void editOrder(String orderId, {DateTime? orderDate, List<OrderItem>? items, OrderStatus? status}) {
    Order? orderToUpdate = orders.firstWhere((order) => order.orderId == orderId, orElse: () => Order.empty());
    if (orderToUpdate.status != OrderStatus.pending) {
      Order updatedOrder = orderToUpdate.copyWith(
        orderDate: orderDate ?? orderToUpdate.orderDate,
        items: items ?? orderToUpdate.items,
        status: status ?? orderToUpdate.status,
      );
      orders[orders.indexWhere((order) => order.orderId == orderId)] = updatedOrder;
      'Order updated !'.toast;
    } else {
      'Order not found !'.toast;
    }
  }
}

final OrderRepository orderManager = OrderRepository.getInstance();

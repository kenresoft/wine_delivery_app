import 'package:flutter/material.dart';

import '../../model/order/order.dart';
import '../../repository/order_repository.dart';
import '../order/order_confirmation.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  _OrderManagementPageState createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Order Management'),
      ),
      body: ListView.builder(
        itemCount: orderManager.orders.length,
        itemBuilder: (context, index) {
          final order = orderManager.orders[index];
          return ListTile(
            title: Text('Order ID: ${order.orderId}'),
            subtitle: Text('Status: ${order.status.toString().split('.').last}'),
            trailing: DropdownButton<OrderStatus>(
              value: order.status,
              items: OrderStatus.values.map((status) {
                return DropdownMenuItem<OrderStatus>(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
              onChanged: (newStatus) {
                setState(() {
                  // Update the order status in the repository
                  orderManager.updateOrderStatus(order.orderId, newStatus!);
                  // Update the UI
                  order.copyWith(status: newStatus);
                });
              },
            ),
            onTap: () {
              // Navigate to a detailed view of the order
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderConfirmationScreen(orderId: order.orderId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class OrderDetailPage extends StatelessWidget {
  final String orderId;

  const OrderDetailPage({required this.orderId, super.key});

  @override
  Widget build(BuildContext context) {
    final order = orderManager.getOrderById(orderId);
    final orderItems = orderManager.getOrderItems(orderId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order - $orderId'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order ID: $orderId'),
          Text('Order Status: ${order.status}'),
          const Text('Order Items:'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: orderItems.length,
            itemBuilder: (context, index) {
              final item = orderItems[index];
              return ListTile(
                title: Text(item.itemName),
                subtitle: Text('Quantity: ${item.quantity}, Price: \$${item.itemPrice}'),
              );
            },
          ),
        ],
      ),
    );
  }
}



/*class OrderStackView extends StatelessWidget {
  const OrderStackView({
    Key? key,
    required this.orderItems,
  }) : super(key: key);

  final List<OrderItem> orderItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 100,
      alignment: Alignment.center,
      child: Stack(
        children: _buildStackItems(),
      ),
    );
  }

  List<Widget> _buildStackItems() {
    List<Widget> stackItems = [];
    var items = orderItems + orderItems; // Duplicate items for even distribution
    final int itemCount = items.length;

    for (int i = 0; i < itemCount; i++) {
      double angle = pi / 4 - (pi / 2) * (i / (itemCount - 1)); // Calculate angle for transformation

      stackItems.add(
        Positioned(
          left: 0,
          top: 0,
          child: Transform(
            origin: const Offset(50, 100),
            transform: Matrix4.identity()..rotateZ(angle),
            child: Image.asset(
              items[i].imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

    return stackItems;
  }
}*/

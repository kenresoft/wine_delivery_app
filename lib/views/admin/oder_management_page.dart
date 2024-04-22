import 'package:flutter/material.dart';
import 'package:wine_delivery_app/service/order_manager.dart';

import '../../model/order_status.dart';

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
                  order.status = newStatus!;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

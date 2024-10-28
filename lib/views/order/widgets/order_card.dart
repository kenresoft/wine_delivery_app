import 'package:flutter/material.dart';

import '../../model/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text('Order #${order.id}'),
          subtitle: Text(
            'Date: ${order.createdAt}\nTotal: \$${order.totalCost.toStringAsFixed(2)}',
          ),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}

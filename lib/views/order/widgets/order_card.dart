import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../model/order.dart';
import '../../../utils/extensions.dart';

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
            'Date: ${order.createdAt}\nTotal: \$${order.totalCost?.toStringAsFixed(2)}',
          ),
          trailing: FontAwesomeIcons.chevronRight.ic,
        ),
      ),
    );
  }
}

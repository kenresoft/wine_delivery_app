import 'package:flutter/material.dart';
import '../../model/order.dart';

class OrderDetailsSection extends StatelessWidget {
  final Order order;

  const OrderDetailsSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order #${order.id}', style: Theme.of(context).textTheme.titleLarge),
        Text('Order Status: ${order.status}'),
        const SizedBox(height: 10),
        Text('Shipping Address: ${order.shipmentId}'),
        Text('Billing Address: ${order.trackingNumber}'),
        Text('Payment Method: ${order.paymentDetails}'),
        const Divider(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: order.items.length,
          itemBuilder: (context, index) {
            final item = order.items[index];
            return ListTile(
              title: Text(item.productId),
              subtitle: Text('Qty: ${item.quantity} | Price: \$${item.quantity}'),
              trailing: Text('\$${item.productId}'),
            );
          },
        ),
      ],
    );
  }
}

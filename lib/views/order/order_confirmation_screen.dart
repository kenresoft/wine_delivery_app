import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/shipment/shipment_bloc.dart';
import '../../../model/order.dart';
import '../../../model/order_product_item.dart';
import '../../../utils/themes.dart';
import 'order_tracking_screens.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Order order;
  /*final String estimatedDelivery;
  final String shippingAddress;
  final num totalCost;*/
  final List<OrderProductItem> orderedItems;

  const OrderConfirmationScreen({
    super.key,
    required this.order,
    /*required this.estimatedDelivery,
    required this.shippingAddress,
    required this.totalCost,*/
    required this.orderedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme(context).tertiary, colorScheme(context).surfaceTint],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildConfirmationMessage(),
              _buildOrderSummaryCard(context),
              _buildShippingInfo(context),
              _buildTrackOrderButton(context, order),
            ],
          ),
        ),
      ),
    );
  }

  // Thank You Message and Order ID
  Widget _buildConfirmationMessage() {
    return Column(
      children: [
        const Text(
          'Thank You!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Your order has been placed successfully',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Order ID: ${order.id}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white60,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // Order Summary Section
  Widget _buildOrderSummaryCard(BuildContext context) {
    final orderNote = order.note?.split(':')[1].trim() ?? 'null';
    return Column(
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // List of Ordered Items
                Column(
                  children: orderedItems.map((item) {
                    return ListTile(
                      leading: Icon(Icons.local_drink_rounded, color: color(context).onSurfaceTextColor),
                      title: Text(item.product.name!, style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: Text('\$${(item.product.defaultPrice! * item.quantity).toStringAsFixed(2)}'),
                    );
                  }).toList(),
                ),
                const Divider(),
                condition(
                  orderNote != 'null',
                  Column(
                    children: [
                      Text(
                        '${order.note}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const Divider(),
                    ],
                  ),
                  const SizedBox(),
                ),
                // Total Cost
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Cost:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${order.totalCost?.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme(context).tertiary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Shipping Info Section
  Widget _buildShippingInfo(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ShipmentBloc, ShipmentState>(
          builder: (context, state) {
            if (state is ShipmentFetched) {
              return Card(
                elevation: 5,
                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Shipping Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Color(0xffBD7879)),
                          Text(
                            ' - Address:',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Text('${state.shipment.address}'),
                      // Text('Address: $shippingAddress'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.access_time_outlined, color: Color(0xffBD7879)),
                          Text(
                            ' - Estimated Time:',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Text(order.createdAt!),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Track Order Button
  Widget _buildTrackOrderButton(BuildContext context, Order order) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return OrderTrackingScreen(order: order);
            }),
          );
        },
        icon: const Icon(Icons.local_shipping, size: 24),
        label: const Text(
          'Track Order',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

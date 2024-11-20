import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/order/order_bloc.dart';
import 'widgets/order_details_section.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<OrderBloc>(context).add(GetOrderById(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoaded) {
            final order = state.order;
            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                OrderDetailsSection(order: order),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Trigger reorder logic
                  },
                  child: const Text('Reorder'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to customer support
                  },
                  child: const Text('Contact Support'),
                ),
              ],
            );
          } else if (state is OrderError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

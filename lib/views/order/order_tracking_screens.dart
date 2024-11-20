import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/model/order.dart';
import 'package:vintiora/repository/socket_repository.dart';
import 'package:vintiora/utils/enums.dart';
import 'package:vintiora/utils/extensions.dart';

import '../../../bloc/order/order_bloc.dart';
import '../../../utils/themes.dart';

class OrderTrackingScreen extends StatefulWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    socketRepository.disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc()..add(GetOrderById(widget.order.id!)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Tracking'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is OrderInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OrderLoaded) {
                return _buildTrackingContent(context, state.order.status!, state.orderProgress);
              } else if (state is OrderError) {
                return _buildErrorState(state.message);
              } else {
                return const Center(child: Text('Unknown state'));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingContent(BuildContext context, OrderStatus currentStage, double orderProgress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),

        // Title
        const Text(
          'Tracking your Order',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        // Display Current Stage
        Text(
          'Current Stage: ${currentStage.toShortString()}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 10),

        // Progress Indicator with color change if order is cancelled
        LinearProgressIndicator(
          value: currentStage == OrderStatus.cancelled ? 1.0 : orderProgress,
          backgroundColor: Colors.grey[300],
          color: currentStage == OrderStatus.cancelled ? Colors.redAccent : Colors.deepPurpleAccent,
          minHeight: 10,
        ),

        const SizedBox(height: 30),

        // Order Stages List with Status Indicators
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderStageIndicator(context, OrderStatus.draft, orderProgress >= 0.0),
            _buildOrderStageIndicator(context, OrderStatus.pending, orderProgress >= 0.2),
            _buildOrderStageIndicator(context, OrderStatus.processing, orderProgress >= 0.4),
            _buildOrderStageIndicator(context, OrderStatus.packaging, orderProgress >= 0.6),
            _buildOrderStageIndicator(context, OrderStatus.shipping, orderProgress >= 0.8),
            _buildOrderStageIndicator(context, OrderStatus.delivered, orderProgress == 1.0),
            _buildOrderStageIndicator(context, OrderStatus.cancelled, currentStage == OrderStatus.cancelled),
          ],
        ),

        const Spacer(),

        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              // Optional: Navigate to a more detailed tracking screen
            },
            icon: const Icon(Icons.local_shipping),
            label: const Text('View Detailed Tracking', maxLines: 1),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderStageIndicator(BuildContext context, OrderStatus stageName, bool isCompleted) {
    return ListTile(
      leading: Icon(
        isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isCompleted ? color(context).onSurfaceTextColor : theme(context).dividerColor,
      ),
      title: Text(
        stageName.toShortString(),
        style: TextStyle(
          fontSize: 18,
          color: isCompleted ? color(context).onSurfaceTextColor : color(context).textColor,
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 18, color: Colors.redAccent),
      ),
    );
  }
}

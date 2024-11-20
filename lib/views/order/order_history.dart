import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/utils/enums.dart';
import 'package:vintiora/utils/extensions.dart';

import '../../../bloc/order/order_bloc.dart';
import '../../../utils/globals.dart';
import 'order_details_screen.dart';
import 'widgets/order_card.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.current) {
      BlocProvider.of<OrderBloc>(context).add(GetUserOrders());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    logger.i('${_scrollController.position.pixels} -- ${_scrollController.position.maxScrollExtent}');
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      // Trigger loading more orders only if more orders are available
      if (BlocProvider.of<OrderBloc>(context).hasMoreOrders) {
        BlocProvider.of<OrderBloc>(context).add(LoadMoreOrders());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Filter and Sort Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton(
                hint: const Text('Filter by Status'),
                items: OrderStatus.values
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    BlocProvider.of<OrderBloc>(context).add(FilterOrdersByStatus(value));
                  }
                },
              ),
              DropdownButton(
                hint: const Text('Sort by'),
                items: ['Date', 'Order Number', 'Total Amount']
                    .map((criterion) => DropdownMenuItem(
                          value: criterion,
                          child: Text(criterion),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    BlocProvider.of<OrderBloc>(context).add(SortOrders(value));
                  }
                },
              ),
            ],
          ),
          // Order List
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrdersLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    physics: ClampingScrollPhysics(),
                    itemCount: state.orders.length + (BlocProvider.of<OrderBloc>(context).hasMoreOrders ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.orders.length) {
                        // Show loading indicator at the end of the list
                        return const Center(child: CircularProgressIndicator());
                      }
                      final order = state.orders[index];
                      return OrderCard(
                        order: order,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsScreen(orderId: order.id!),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is OrderError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

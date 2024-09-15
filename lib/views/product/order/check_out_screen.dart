import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/repository/order_repository.dart';
import 'package:wine_delivery_app/utils/extensions.dart';
import 'package:wine_delivery_app/views/product/order/shipping_form_address.dart';

import '../../../bloc/product/product_bloc.dart';
import '../../../bloc/shipment/shipment_bloc.dart';
import '../../../model/order.dart';
import '../../../model/order_item.dart';
import 'order_stack_view.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final Order order;

  const OrderConfirmationScreen({required this.order, super.key});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    _loadProducts(); // Trigger the loading of products when the widget initializes
  }

  void _loadProducts() {
    final productIds = widget.order.items.map((item) => item.productId).toList();
    context.read<ProductBloc>().add(GetProductsByIds(productIds));
    context.read<ShipmentBloc>().add(GetShipmentDetailsById(widget.order.shipmentId));
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final orderItems = order.items;
    final status = order.status;
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF9F6),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildAppBar(context),
              buildHeaderSection(orderItems, order, status),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme(context).primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              buildSummarySection(orderItems),
              //const SizedBox(height: 20),
              buildDetailsSection(context, order),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildDetailsSection(BuildContext context, Order order) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text(
            'Order Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme(context).primary,
            ),
          ),
          const SizedBox(height: 10),
          buildOrderCard(context, order),
          const SizedBox(height: 20),
          Text(
            'Delivery Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme(context).primary,
            ),
          ),
          const SizedBox(height: 10),
          buildDeliveryCard(),
          Text(
            'Payment Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme(context).primary,
            ),
          ),
          const SizedBox(height: 10),
          buildPaymentCard(context),
          const SizedBox(height: 20),
          buildFooterButtons(context, order.id),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Row buildFooterButtons(BuildContext context, String orderId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ShippingAddressForm(),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme(context).primary,
            foregroundColor: Colors.white,
            maximumSize: const Size(250, 148),
          ),
          child: const Text('Edit Order'),
        ),
        ElevatedButton(
          onPressed: () async {
            /*final isIntentCreated = await orderRepository.makePurchase(
              orderId: orderId,
              description: "_description",
              currency: "gbp",
              paymentMethod: "_paymentMethod",
            );
            if (isIntentCreated) {
              'created'.toast;
            }*/

          },
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme(context).primary,
            foregroundColor: Colors.white,
            maximumSize: const Size(250, 148),
          ),
          child: const Text('Place Order'),
        ),
      ],
    );
  }

  Card buildPaymentCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Payment Method:',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme(context).primaryContainer,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Row(
              children: [
                Icon(Icons.payment_outlined, color: Color(0xffBD7879)),
                Text(' Credit Card'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildAppBar(BuildContext context) {
    return Container(
      color: const Color(0xffF4F4F4),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ).copyWith(top: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(CupertinoIcons.chevron_left),
            ),
          ],
        ),
      ),
    );
  }

  Container buildHeaderSection(List<OrderItem> orderItems, Order order, String status) {
    return Container(
      height: 230,
      padding: const EdgeInsets.all(42).copyWith(right: 16),
      decoration: const BoxDecoration(
        color: Color(0xffF4F4F4),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(90)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OrderStackView(orderItems: orderItems),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Text(
                    'Order Id: ',
                    style: TextStyle(
                      fontSize: 21,
                      color: Color(0xffBD7879),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    order.totalCost.toString(),
                    // order.id,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Status: ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffBD7879),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    status.replaceFirst(
                      status.characters.first,
                      status.characters.first.toUpperCase(),
                    ),
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  BlocBuilder<ProductBloc, ProductState> buildSummarySection(List<OrderItem> orderItems) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          return SizedBox(
            height: 105,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  orderItems.length,
                  (index) {
                    final item = orderItems[index];
                    final product = state.products[index];

                    orderItems.sort((a, b) => a.productId.compareTo(b.productId));
                    state.products.sort((a, b) => a.id.compareTo(b.id));

                    return Card(
                      margin: EdgeInsets.only(
                        left: index == 0 ? 16 : 8,
                        right: index == orderItems.length - 1 ? 16 : 8,
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(minWidth: 120),
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Quantity: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colorScheme(context).primaryContainer,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Price: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colorScheme(context).primaryContainer,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '\$${product.price}',
                                  style: const TextStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Card buildOrderCard(BuildContext context, Order order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal:',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme(context).primaryContainer,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text('\$${order.subTotal}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Value Added Tax:',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme(context).primaryContainer,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Text('\$3.00'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Fee:',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme(context).primaryContainer,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text('\$${order.shipmentId}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${order.totalCost}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder<ShipmentBloc, ShipmentState> buildDeliveryCard() {
    return BlocBuilder<ShipmentBloc, ShipmentState>(
      builder: (context, state) {
        if (state is ShipmentLoaded) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Delivery Address:',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme(context).primaryContainer,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Color(0xffBD7879)),
                      Text(state.shipment.address.toString()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Estimated Delivery Time:',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme(context).primaryContainer,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.access_time_outlined, color: Color(0xffBD7879)),
                      Text(' 30 minutes'),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
}

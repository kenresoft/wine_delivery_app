import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/product/product_bloc.dart';
import '../../../bloc/shipment/shipment_bloc.dart';
import '../../../model/order.dart';
import '../../../model/order_item.dart';
import '../../../model/order_product_item.dart';
import '../../../model/product.dart';
import '../../../repository/order_repository.dart';
import '../../../repository/product_repository.dart';
import '../../../utils/helpers.dart';
import 'order_confirmation_screen.dart';
import 'products_stack_view.dart';
import 'shipping_form_address.dart';

class CheckOutScreen extends StatefulWidget {
  final Order order;

  const CheckOutScreen({required this.order, super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadProducts();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint(state.name);
    if (state == AppLifecycleState.resumed) {
      _loadProducts();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the navigation triggered a dependency change
    if (ModalRoute.of(context)?.isCurrent != true) {
      //
    } else {
      // Resume stateful operations here
      context.read<ShipmentBloc>().add(GetShipmentDetailsById(widget.order.shipmentId));
    }
  }

  void _loadProducts() {
    final productIds = widget.order.items.map((item) => item.productId).toList();
    context.read<ProductBloc>().add(GetProductsByIds(productIds));
    context.read<ShipmentBloc>().add(GetShipmentDetailsById(widget.order.shipmentId));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final orderItems = order.items;
    final status = order.status;
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(orderItems, order, status.toShortString()),
            _buildOrderSummary(orderItems),
            _buildOrderDetails(context, order),
            _buildDeliveryInformation(context, order),
            _buildPaymentInformation(context),
            _buildFooterButtons(context, order),
          ],
        ),
      ),
    );
  }

  Container _buildHeader(List<OrderItem> orderItems, Order order, String status) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: color(context).primaryContainerColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(80),
          bottomLeft: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(42).copyWith(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProductsStackView(orderItems: orderItems),
                Flexible(
                  child: SizedBox(
                    height: 100.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: 120.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: const Text(
                                    'Status: ',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20,
                                      height: 1,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    status.replaceFirst(
                                      status.characters.first,
                                      status.characters.first.toUpperCase(),
                                    ),
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: 150.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Order Id: ',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    order.id.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(List<OrderItem> orderItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme(context).tertiary,
            ),
          ),
        ),
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductsLoaded) {
              final products = state.products;

              final orderProductItems = orderItems
                  .map((item) {
                    final product = products.firstWhere(
                      (product) => product.id == item.productId,
                      orElse: () => Product(), // Handle missing product here
                    );

                    if (product == Product()) {
                      // Handle the case where the product is not found -- We simply Refresh the state
                      context.read<ShipmentBloc>().add(GetShipmentDetailsById(widget.order.shipmentId));
                      return null;
                    }

                    return OrderProductItem(
                      product: product,
                      quantity: item.quantity,
                    );
                  })
                  .where((item) => item != null)
                  .toList();

              return SizedBox(
                height: 105,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      orderItems.length,
                      (index) {
                        final item = orderProductItems[index];

                        return Card(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 20 : 8,
                            right: index == orderItems.length - 1 ? 20 : 8,
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            padding: const EdgeInsets.all(12),
                            constraints: const BoxConstraints(minWidth: 120),
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item?.product.name ?? 'Product Name Error!',
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Quantity: ',
                                      style: const TextStyle(fontWeight: FontWeight.w300),
                                    ),
                                    Text('${item?.quantity}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Unit Price: ',
                                      style: TextStyle(fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      '\$${item?.product.defaultPrice}',
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
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Divider(),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(BuildContext context, Order order) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme(context).tertiary,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Subtotal:',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Flexible(child: Text('\$${order.subTotal.toStringAsFixed(2)}')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Value Added Tax:',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      const Text('\$3.00'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Delivery Fee:',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                      Flexible(child: Text('\$${order.shipmentId}')),
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
                      Flexible(
                        child: Text(
                          '\$${order.totalCost.toStringAsFixed(2)}',
                          maxLines: 1,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildDeliveryInformation(BuildContext context, Order order) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme(context).tertiary,
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<ShipmentBloc, ShipmentState>(
            builder: (context, state) {
              if (state is ShipmentFetched) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Delivery Address:',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Color(0xffBD7879)),
                            Flexible(child: Text(state.shipment.address.toString())),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Estimated Delivery Time:',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.access_time_outlined, color: Color(0xffBD7879)),
                            Flexible(child: Text(' 30 minutes')),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildPaymentInformation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme(context).tertiary,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Payment Method:',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.payment_outlined, color: Color(0xffBD7879)),
                      Flexible(child: Text(' Credit Card')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButtons(BuildContext context, Order order) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 6,
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ShippingAddressForm(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.chevron_left),
                      Flexible(child: const Text('Edit Order', maxLines: 2)),
                    ],
                  )),
            ),
          ),
          Spacer(),
          Flexible(
            flex: 6,
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  onPressed: () async => await _placeOrder(order, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: const Text('Place Order', maxLines: 2),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(Order order, BuildContext context) async {
    // Fetch all products concurrently using Future.wait
    final items = await Future.wait(
      order.items.map((item) async {
        final product = await productRepository.getProductById(item.productId);
        return OrderProductItem(product: product, quantity: item.quantity);
      }).toList(),
    );

    if (Platform.isIOS || Platform.isAndroid || kIsWeb) {
      await orderRepository.makePurchase(
        orderId: order.id,
        description: "_description",
        currency: "usd",
        // currency: "gpb", // currency: "ngn", // currency: "euro"
        paymentMethod: "_paymentMethod",
        callback: (bool success, {String? message}) {
          if (success) {
            // Show success message and navigate to order confirmation screen
            snackBar(context, 'Order created successfully!');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return OrderConfirmationScreen(
                    order: order,
                    estimatedDelivery: order.createdAt,
                    shippingAddress: order.shipmentId,
                    totalCost: order.totalCost,
                    orderedItems: items,
                  );
                },
              ),
            );
          } else {
            snackBar(context, message ?? 'Failed to create order');
          }
        },
      );
    } else {
      // Show success message and navigate to order confirmation screen
      snackBar(context, 'Order created successfully!');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return OrderConfirmationScreen(
              order: order,
              estimatedDelivery: order.createdAt,
              shippingAddress: order.shipmentId,
              totalCost: order.totalCost,
              orderedItems: items,
            );
          },
        ),
      );
    }
  }
}

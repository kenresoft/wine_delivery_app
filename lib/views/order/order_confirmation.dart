import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../repository/order_repository.dart';
import 'order_stack_view.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String orderId;

  const OrderConfirmationScreen({required this.orderId, super.key});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final order = orderManager.getOrderById(widget.orderId);
    final orderItems = orderManager.getOrderItems(widget.orderId);
    final status = order.status.name;
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF9F6),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
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
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, 'cart_page'),
                        child: Stack(
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 30.r, color: const Color(0xff383838)),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                alignment: Alignment.center,
                                width: 16.w,
                                height: 16.w,
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    color: const Color(0xffBD7879),
                                    borderRadius: BorderRadius.circular(40)),
                                child: FittedBox(
                                  child: BlocBuilder<CartBloc, CartState>(
                                    builder: (context, state) {
                                      return Text(
                                        //'${cartManager.cartItems.length}',
                                        '${state.cartItems.length}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10, color: Colors.white),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
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
                              style: TextStyle(fontSize: 21, color: Color(0xffBD7879), fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.orderId,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Status: ',
                              style: TextStyle(fontSize: 18, color: Color(0xffBD7879), fontWeight: FontWeight.w500),
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
              ),
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
              SizedBox(
                height: 105,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      orderItems.length,
                          (index) {
                        final item = orderItems[index];
                        return Card(
                          margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: index == orderItems.length - 1 ? 16 : 8),
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
                                  item.itemName,
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
                                      '\$${item.itemPrice}',
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
              ),
              //const SizedBox(height: 20),
              Padding(
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
                    Card(
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
                                const Text('\$30.00'),
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
                                const Text('\$5.00'),
                              ],
                            ),
                            const Divider(),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$38.00',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
                    Card(
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
                            const Row(
                              children: [
                                Icon(Icons.location_on_outlined, color: Color(0xffBD7879)),
                                Text(' 123 Main St, Anytown'),
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
                    ),
                    Text(
                      'Payment Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme(context).primary,
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
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Edit Order button action
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: colorScheme(context).primary,
                            foregroundColor: Colors.white,
                            maximumSize: const Size(250, 148),
                          ),
                          child: const Text('Edit Order'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Edit Order button action
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: colorScheme(context).primary,
                            foregroundColor: Colors.white,
                            maximumSize: const Size(250, 148),
                          ),
                          child: const Text('Place Order'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
}
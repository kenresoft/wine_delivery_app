import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/example.dart';
import 'package:wine_delivery_app/model/order_item.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_state.dart';
import '../../auth_modal.dart';
import '../../model/order_status.dart';
import '../../repository/order_repository.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  _OrderManagementPageState createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Order Management'),
      ),
      body: ListView.builder(
        itemCount: orderManager.orders.length,
        itemBuilder: (context, index) {
          final order = orderManager.orders[index];
          return ListTile(
            title: Text('Order ID: ${order.orderId}'),
            subtitle: Text('Status: ${order.status.toString().split('.').last}'),
            trailing: DropdownButton<OrderStatus>(
              value: order.status,
              items: OrderStatus.values.map((status) {
                return DropdownMenuItem<OrderStatus>(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
              onChanged: (newStatus) {
                setState(() {
                  // Update the order status in the repository
                  orderManager.updateOrderStatus(order.orderId, newStatus!);
                  // Update the UI
                  order.copyWith(status: newStatus);
                });
              },
            ),
            onTap: () {
              // Navigate to a detailed view of the order
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderConfirmationScreen(orderId: order.orderId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class OrderDetailPage extends StatelessWidget {
  final String orderId;

  const OrderDetailPage({required this.orderId, super.key});

  @override
  Widget build(BuildContext context) {
    final order = orderManager.getOrderById(orderId);
    final orderItems = orderManager.getOrderItems(orderId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order - $orderId'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order ID: $orderId'),
          Text('Order Status: ${order.status}'),
          const Text('Order Items:'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: orderItems.length,
            itemBuilder: (context, index) {
              final item = orderItems[index];
              return ListTile(
                title: Text(item.itemName),
                subtitle: Text('Quantity: ${item.quantity}, Price: \$${item.itemPrice}'),
              );
            },
          ),
        ],
      ),
    );
  }
}

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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffBD7879)),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: Color(0xffBD7879), width: 1),
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
                                  item.itemName,
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    const Text('Quantity: ',
                                      style: TextStyle(fontSize: 16, color: Color(0xffBD7879), fontWeight: FontWeight.w300),),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Price: ',
                                      style: TextStyle(fontSize: 16, color: Color(0xffBD7879), fontWeight: FontWeight.w300),),
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
                    const Text(
                      'Order Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffBD7879)),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Color(0xffBD7879), width: 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal:',
                                  style: TextStyle(fontSize: 16, color: Color(0xffBD7879), fontWeight: FontWeight.w300),
                                ),
                                Text('\$30.00'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Value Added Tax:',
                                  style: TextStyle(fontSize: 16, color: Color(0xffBD7879), fontWeight: FontWeight.w300),
                                ),
                                Text('\$3.00'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Fee:',
                                  style: TextStyle(fontSize: 16, color: Color(0xffBD7879), fontWeight: FontWeight.w300),
                                ),
                                Text('\$5.00'),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(fontSize: 18, color: Color(0xffBD7879), fontWeight: FontWeight.bold),
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
                    const Text(
                      'Delivery Information',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffBD7879)),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xffBD7879), width: 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Delivery Address:',
                              style: TextStyle(fontSize: 16, color: Color(0xffBD7879), fontWeight: FontWeight.w300),
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, color: Color(0xffBD7879)),
                                Text(' 123 Main St, Anytown'),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Estimated Delivery Time:',
                              style: TextStyle(fontSize: 16, color: Color(0xffBD7879), fontWeight: FontWeight.w300),
                            ),
                            Row(
                              children: [
                                Icon(Icons.access_time_outlined, color: Color(0xffBD7879)),
                                Text(' 30 minutes'),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const Text(
                      'Payment Information',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffBD7879)),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xffBD7879), width: 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Payment Method:',
                              style: TextStyle(fontSize: 16, color: Color(0xffBD7879), fontWeight: FontWeight.w300),
                            ),
                            Row(
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
                        OutlinedButton(
                          onPressed: () {
                            // Edit Order button action
                          },
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.white),
                              side: MaterialStatePropertyAll(
                                BorderSide(color: Color(0xffBD7879)),
                              )),
                          child: const Text('Edit Order'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            // Edit Order button action
                          },
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.white),
                              side: MaterialStatePropertyAll(
                                BorderSide(color: Color(0xffBD7879)),
                              )),
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
}

/*
class OrderStackView extends StatefulWidget {
  const OrderStackView({
    super.key,
    required this.orderItems,
  });

  final List<OrderItem> orderItems;

  @override
  State<OrderStackView> createState() => _OrderStackViewState();
}

class _OrderStackViewState extends State<OrderStackView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward(); // Start the animation
    return Container(
      width: 150,
      height: 100,
      alignment: Alignment.center,
      child: Stack(
        children: _buildStackItems(),
      ),
    );
  }

  List<Widget> _buildStackItems() {
    List<Widget> stackItems = [];
    var items = widget.orderItems + widget.orderItems; // Duplicate items
    final int itemCount = items.length - 1;

    // Calculate the middle item index
    int middleIndex = itemCount ~/ 2;

    // Create a list to store the indices in the specified order
    List<int> indices = [];

    // Add indices from the middle according to the specified order
    if (itemCount % 2 == 0) {
      // For even number of items
      for (int i = 0; i < middleIndex; i++) {
        indices.add(middleIndex + i);
        indices.add(middleIndex - i - 1);
      }
    } else {
      // For odd number of items
      indices.add(middleIndex);
      for (int i = 1; i <= middleIndex; i++) {
        indices.add(middleIndex + i);
        indices.add(middleIndex - i);
      }
    }

    // Build stack items using the calculated indices
    for (int index in indices.reversed) {
      double angle = pi / 4 - (pi / 2) * (index / (itemCount - 1));

      stackItems.add(
        Positioned(
          left: 0,
          top: 0,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Transform(
              origin: const Offset(50, 100),
              transform: Matrix4.identity()..rotateZ(angle),
              child: Image.asset(
                items[index].imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    }

    return stackItems;
  }
}
*/

class OrderStackView extends StatelessWidget {
  const OrderStackView({
    super.key,
    required this.orderItems,
  });

  final List<OrderItem> orderItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      alignment: Alignment.center,
      child: Stack(
        children: _buildStackItems(),
      ),
    );
  }

  List<Widget> _buildStackItems() {
    List<Widget> stackItems = [];
    var items = orderItems.take(11).toList(); // Take only the first 11 items
    final int itemCount = items.length;

    if (itemCount == 1) {
      // Only one item, no need for stacking
      stackItems.add(
        Positioned(
          left: 0,
          top: 0,
          child: Image.asset(
            items[0].imageUrl,
            width: 130,
            height: 130,
            fit: BoxFit.contain,
          ),
        ),
      );
      return stackItems;
    }

    // Calculate the index of the middle item
    int middleIndex = itemCount ~/ 2;

    // Create a list to store the indices in the specified order
    List<int> indices = [];

    // Add indices from the middle according to the specified order
    if (itemCount % 2 == 0) {
      // For even number of items
      for (int i = 0; i < middleIndex; i++) {
        indices.add(middleIndex + i);
        indices.add(middleIndex - i - 1);
      }
    } else {
      // For odd number of items
      indices.add(middleIndex);
      for (int i = 1; i <= middleIndex; i++) {
        indices.add(middleIndex + i);
        indices.add(middleIndex - i);
      }
    }

    // Build stack items using the calculated indices
    for (int index in indices.reversed) {
      double angle = pi / 4 - (pi / 2) * (index / (itemCount - 1)); // Calculate angle for transformation

      stackItems.add(
        Positioned(
          left: 0,
          top: 0,
          child: Transform(
            origin: const Offset(65, 130),
            transform: Matrix4.identity()..rotateZ(angle),
            child: Image.asset(
              items[index].imageUrl,
              width: 130,
              height: 130,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

    return stackItems;
  }
}

/*class OrderStackView extends StatelessWidget {
  const OrderStackView({
    Key? key,
    required this.orderItems,
  }) : super(key: key);

  final List<OrderItem> orderItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 100,
      alignment: Alignment.center,
      child: Stack(
        children: _buildStackItems(),
      ),
    );
  }

  List<Widget> _buildStackItems() {
    List<Widget> stackItems = [];
    var items = orderItems + orderItems; // Duplicate items for even distribution
    final int itemCount = items.length;

    for (int i = 0; i < itemCount; i++) {
      double angle = pi / 4 - (pi / 2) * (i / (itemCount - 1)); // Calculate angle for transformation

      stackItems.add(
        Positioned(
          left: 0,
          top: 0,
          child: Transform(
            origin: const Offset(50, 100),
            transform: Matrix4.identity()..rotateZ(angle),
            child: Image.asset(
              items[i].imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

    return stackItems;
  }
}*/

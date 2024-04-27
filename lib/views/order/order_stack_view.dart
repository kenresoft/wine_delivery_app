import 'dart:math';

import 'package:flutter/material.dart';

import '../../model/order/order.dart';

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
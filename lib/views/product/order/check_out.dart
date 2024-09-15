import 'package:flutter/material.dart';

class CheckOut extends StatelessWidget {
  final String orderNumber = "123456";
  final String orderDate = "2024-06-01";
  final String orderTime = "14:35";
  final String shippingAddress = "123 Wine Street, Vineyard City, CA 12345";
  final String paymentMethod = "Credit Card ending in 1234";
  final List<Map<String, String>> orderItems = [
    {"name": "Red Wine", "quantity": "2", "price": "\$40"},
    {"name": "White Wine", "quantity": "1", "price": "\$25"},
  ];

  CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Implement navigation back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderSummary(
                orderNumber: orderNumber,
                orderDate: orderDate,
                orderTime: orderTime),
            const SizedBox(height: 20),
            OrderDetails(orderItems: orderItems),
            const SizedBox(height: 20),
            ShippingInformation(shippingAddress: shippingAddress),
            const SizedBox(height: 20),
            PaymentInformation(paymentMethod: paymentMethod),
            const SizedBox(height: 20),
            const OrderStatus(),
            const SizedBox(height: 20),
            const CallToAction(),
          ],
        ),
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final String orderNumber;
  final String orderDate;
  final String orderTime;

  const OrderSummary({
    super.key,
    required this.orderNumber,
    required this.orderDate,
    required this.orderTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Number: $orderNumber',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Order Date: $orderDate',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text('Order Time: $orderTime',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class OrderDetails extends StatelessWidget {
  final List<Map<String, String>> orderItems;

  const OrderDetails({super.key, required this.orderItems});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ...orderItems.map((item) => ListTile(
                  title: Text(item["name"]!),
                  subtitle: Text('Quantity: ${item["quantity"]}'),
                  trailing: Text(item["price"]!),
                )),
          ],
        ),
      ),
    );
  }
}

class ShippingInformation extends StatelessWidget {
  final String shippingAddress;

  const ShippingInformation({super.key, required this.shippingAddress});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Shipping Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            Text(shippingAddress, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class PaymentInformation extends StatelessWidget {
  final String paymentMethod;

  const PaymentInformation({super.key, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            Text(paymentMethod, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class OrderStatus extends StatelessWidget {
  const OrderStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Divider(),
            Text('Your order is being processed',
                style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class CallToAction extends StatelessWidget {
  const CallToAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            // Implement order tracking navigation
          },
          child: const Text('Track Order'),
        ),
        ElevatedButton(
          onPressed: () {
            // Implement return to home navigation
          },
          child: const Text('Return to Home'),
        ),
      ],
    );
  }
}

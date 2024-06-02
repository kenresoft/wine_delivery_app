import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderNumber = "123456";
  final String orderDate = "2024-06-01";
  final String orderTime = "14:35";
  final String shippingAddress = "123 Wine Street, Vineyard City, CA 12345";
  final String paymentMethod = "Credit Card ending in 1234";
  final List<Map<String, String>> orderItems = [
    {"name": "Red Wine", "quantity": "2", "price": "\$40"},
    {"name": "White Wine", "quantity": "1", "price": "\$25"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            OrderSummary(orderNumber: orderNumber, orderDate: orderDate, orderTime: orderTime),
            SizedBox(height: 20),
            OrderDetails(orderItems: orderItems),
            SizedBox(height: 20),
            ShippingInformation(shippingAddress: shippingAddress),
            SizedBox(height: 20),
            PaymentInformation(paymentMethod: paymentMethod),
            SizedBox(height: 20),
            OrderStatus(),
            SizedBox(height: 20),
            CallToAction(),
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
            Text('Order Number: $orderNumber', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Order Date: $orderDate', style: TextStyle(fontSize: 14)),
            SizedBox(height: 4),
            Text('Order Time: $orderTime', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class OrderDetails extends StatelessWidget {
  final List<Map<String, String>> orderItems;

  const OrderDetails({required this.orderItems});

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
            Text('Order Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Divider(),
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

  const ShippingInformation({required this.shippingAddress});

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
            Text('Shipping Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Divider(),
            Text(shippingAddress, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class PaymentInformation extends StatelessWidget {
  final String paymentMethod;

  const PaymentInformation({required this.paymentMethod});

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
            Text('Payment Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Divider(),
            Text(paymentMethod, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class OrderStatus extends StatelessWidget {
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
            Text('Order Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Divider(),
            Text('Your order is being processed', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class CallToAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            // Implement order tracking navigation
          },
          child: Text('Track Order'),
        ),
        ElevatedButton(
          onPressed: () {
            // Implement return to home navigation
          },
          child: Text('Return to Home'),
        ),
      ],
    );
  }
}

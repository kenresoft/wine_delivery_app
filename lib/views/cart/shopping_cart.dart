import 'package:flutter/material.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  int _selectedIndex = 2; // Set the initial index to the Cart tab

  final List<Map<String, dynamic>> cartItems = [
    {
      "name": "Red Wine",
      "quantity": 2,
      "price": 20.0,
      "image": "assets/images/wine-1.png",
    },
    {
      "name": "White Wine",
      "quantity": 1,
      "price": 25.0,
      "image": "assets/images/wine-2.png",
    },
    {
      "name": "White Wine",
      "quantity": 1,
      "price": 25.0,
      "image": "assets/images/wine-3.png",
    },
    {
      "name": "White Wine",
      "quantity": 1,
      "price": 25.0,
      "image": "assets/images/wine-4.png",
    },
    {
      "name": "White Wine",
      "quantity": 1,
      "price": 25.0,
      "image": "assets/images/wine-5.png",
    },
    {
      "name": "White Wine",
      "quantity": 1,
      "price": 25.0,
      "image": "assets/images/wine-6.png",
    },
    {
      "name": "White Wine",
      "quantity": 1,
      "price": 25.0,
      "image": "assets/images/wine-7.png",
    },
    {
      "name": "White Wine",
      "quantity": 1,
      "price": 25.0,
      "image": "assets/images/wine-8.png",
    },
    {
      "name": "White Wine",
      "quantity": 1,
      "price": 25.0,
      "image": "assets/images/wine-9.png",
    },
    {
      "name": "White Wine",
      "quantity": 1,
      "price": 25.0,
      "image": "assets/images/wine-10.png",
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Implement navigation to other sections based on the index
    });
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
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
          children: [
            Expanded(child: CartItemsList(cartItems: cartItems)),
            SubtotalSection(subtotal: subtotal),
            const PromoCodeInput(),
            CheckoutButton(subtotal: subtotal),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CartItemsList extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartItemsList({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Image.asset(item['image'],
                width: 50, height: 50, fit: BoxFit.cover),
            title: Text(item['name'],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text('Quantity: ${item['quantity']}'),
            trailing: Text(
                '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
          ),
        );
      },
    );
  }
}

class SubtotalSection extends StatelessWidget {
  final double subtotal;

  const SubtotalSection({super.key, required this.subtotal});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('\$${subtotal.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class PromoCodeInput extends StatelessWidget {
  const PromoCodeInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Enter promo code',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Implement promo code application
            },
          ),
        ),
      ),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  final double subtotal;

  const CheckoutButton({super.key, required this.subtotal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // Implement checkout navigation
        },
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text('Proceed to Checkout', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

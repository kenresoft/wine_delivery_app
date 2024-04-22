import 'package:flutter/material.dart';
import 'package:wine_delivery_app/service/order_manager.dart';
import 'package:wine_delivery_app/utils/utils.dart';

import '../../service/cart_manager.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cartManager.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartManager.cartItems[index];
          return ListTile(
            title: Text(cartItem.itemName),
            subtitle: Text('\$${cartItem.itemPrice} x ${cartItem.quantity}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  cartManager.removeFromCart(index);
                  '${cartItem.itemName} removed from cart d,mv,msd,m,mf,sdm,mf,md,fm!'.toasts(context);
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: \$${cartManager.getTotalPrice()}'),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  orderManager.createOrder();
                  Navigator.pushNamed(context, 'order_management_page');
                },
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

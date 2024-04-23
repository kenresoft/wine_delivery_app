import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wine_delivery_app/service/order_manager.dart';
import 'package:wine_delivery_app/utils/utils.dart';
import 'package:wine_delivery_app/views/product/product_button.dart';

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
        backgroundColor: const Color(0xffFfffff),
        surfaceTintColor: const Color(0xffFfffff),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(right: 8, bottom: 6),
            color: Colors.transparent,
            child: const Icon(CupertinoIcons.chevron_left),
          ),
        ),
      ),
      backgroundColor: const Color(0xffFfffff),
      body: ListView.builder(
        itemCount: cartManager.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartManager.cartItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            color: const Color(0xffF4F4F4),
            surfaceTintColor: const Color(0xffF4F4F4),
            child: ListTile(
              leading: Image.asset(cartItem.imageUrl),
              title: Text(cartItem.itemName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: \$${cartItem.itemPrice}'),
                  Text('(\$${cartItem.itemPrice} x ${cartItem.quantity})'),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Color(0xffBD7879)),
                    onPressed: () {
                      setState(() {
                        cartManager.decreaseQuantity(index);
                      });
                    },
                  ),
                  Text('${cartItem.quantity}'),
                  IconButton(
                    icon: const Icon(Icons.add, color: Color(0xff7D557A)),
                    onPressed: () {
                      setState(() {
                        cartManager.increaseQuantity(index);
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        cartManager.removeFromCart(cartItem.itemName);
                        '${cartItem.itemName} removed from cart!'.toast;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Card(
        color: const Color(0xff394346),
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: BottomAppBar(
          height: 110,
          color: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(
                            text: 'Estimated Cost: ',
                            style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '\$${cartManager.getTotalPrice()}',
                            style: const TextStyle(color: Color(0xffBD7879)),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(
                            text: 'Purchase Cost: ',
                            style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '\$${cartManager.calculatePurchaseCost()}',
                            style: const TextStyle(color: Color(0xff886883)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          const TextSpan(
                            text: 'Total Cost: ',
                            style: TextStyle(fontSize: 18, color: Colors.white54, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '\$${cartManager.getTotalPrice() + cartManager.calculatePurchaseCost()}',
                            style: const TextStyle(fontSize: 18, color: Color(0xffF69202)),
                          ),
                        ],
                      ),
                    ),
                    ProductButton(
                      width: 180,
                      margin: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {});
                        orderManager.createOrder();
                        Navigator.pushNamed(context, 'order_management_page');
                      },
                      text: 'Checkout',
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

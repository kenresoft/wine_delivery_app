import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/bloc/cart/cart_bloc.dart';
import 'package:wine_delivery_app/utils/utils.dart';
import 'package:wine_delivery_app/views/product/product_button.dart';

import '../../repository/cart_repository.dart';
import '../../repository/order_repository.dart';

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
        backgroundColor: const Color(0xFFFAF9F6),
        surfaceTintColor: const Color(0xFFFAF9F6),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(right: 8, bottom: 6),
            color: Colors.transparent,
            child: const Icon(CupertinoIcons.chevron_left),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFAF9F6),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartManager.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartManager.cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  color: const Color(0xffF4F4F4),
                  surfaceTintColor: const Color(0xffF4F4F4),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: Image.asset(cartItem.imageUrl, width: 42, fit: BoxFit.contain),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16, left: 8),
                              child: Text(
                                cartItem.itemName,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ),
                            ListTile(
                              /*title: const Text(
                                'Sparkling wine',
                                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                              ),*/
                              minVerticalPadding: 0,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Price: ',
                                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                                      ),
                                      Text(
                                        '\$${cartItem.itemPrice}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xffBD7879),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Text(
                                        'Quantity: ',
                                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                                      ),
                                      Text(
                                        '${cartItem.quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xffBD7879),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 0),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                                    icon: const Icon(Icons.remove, color: Color(0xffBD7879)),
                                    onPressed: () {
                                      setState(() {
                                        cartManager.decreaseQuantity(index);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                    child: Text(
                                      '${cartItem.quantity}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  IconButton(
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                                    icon: const Icon(Icons.add, color: Color(0xff7D557A)),
                                    onPressed: () {
                                      setState(() {
                                        cartManager.increaseQuantity(index);
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(CupertinoIcons.delete, color: Color(0xffBD7879)),
                                    onPressed: () {
                                      setState(() {
                                        context.read<CartBloc>().add(RemoveFromCartEvent(cartItem.itemName));
                                        //cartManager.removeFromCart(cartItem.itemName);
                                        '${cartItem.itemName} removed from cart!'.toast;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16, left: 8),
                              child: Row(
                                children: [
                                  const Text(
                                    'Discount: ',
                                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                                  ),
                                  Text(
                                    '${cartItem.purchaseCost}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Color(0xff394346),
                                      color: Color(0xffBD7879),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: ListTile(
              leading: const Icon(CupertinoIcons.money_dollar_circle, size: 26),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estimated Price:', style: TextStyle(fontSize: 17)),
                  Text(
                    '\$${cartManager.getTotalPrice().toStringAsFixed(2)}',
                    style: const TextStyle(color: Color(0xffBD7879)),
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('VAT:'),
                  Text(
                    '\$${cartManager.calculatePurchaseCost().toStringAsFixed(2)}',
                    style: const TextStyle(color: Color(0xffBD7879)),
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            ),
          ),
        ],
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total: ',
                            style: TextStyle(fontSize: 28, color: Colors.white54, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${double.parse(cartManager.getTotalPrice().toStringAsFixed(2)) + cartManager.calculatePurchaseCost()}',
                            style: const TextStyle(fontSize: 28, color: Color(0xffBD7879)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ProductButton(
                      width: 150,
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

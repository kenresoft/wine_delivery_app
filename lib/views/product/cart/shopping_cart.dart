import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/repository/order_repository.dart';
import 'package:wine_delivery_app/utils/utils.dart';

import '../../../bloc/cart/cart_bloc.dart';
import '../../../bloc/navigation/bottom_navigation_bloc.dart';
import '../../../bloc/order/order_bloc.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../repository/cart_repository.dart';
import '../order/order_confirmation.dart';

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
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        if (state != const PageChanged(selectedIndex: 3)) {
          return const Center(child: CircularProgressIndicator());
        } else {
          context.read<ProfileBloc>().add(const ProfileFetch());
          double subtotal = cartItems.fold(0, (sum, item) {
            return sum + (item['price'] * item['quantity']);
          });

          return BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.grey.shade300,
                appBar: AppBar(
                  title: Text('Shopping Cart - ${state.cartItems.length} items'),
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
                const Expanded(child: CartItemsList()),
                SubtotalSection(subtotal: subtotal),
                const PromoCodeInput(),
                CheckoutButton(subtotal: subtotal),
              ],
            ),
          ),
        );
      },
    );
        }
      },
    );
  }
}

class CartItemsList extends StatefulWidget {
  //final List<Map<String, dynamic>> cartItems;

  const CartItemsList({
    super.key,
    /*required this.cartItems*/
  });

  @override
  State<CartItemsList> createState() => _CartItemsListState();
}

class _CartItemsListState extends State<CartItemsList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: cartManager.cartItems.length,
          itemBuilder: (context, index) {
            final cartItem = cartManager.cartItems[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Image.asset(cartItem.imageUrl, width: 50, height: 50, fit: BoxFit.contain),
                title: Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Text(
                        cartItem.itemName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
                      icon: const Icon(Icons.remove, color: Color(0xffBD7879), size: 15),
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
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
                      icon: const Icon(Icons.add, color: Color(0xff7D557A), size: 15),
                      onPressed: () {
                        setState(() {
                          cartManager.increaseQuantity(index);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.delete, color: Color(0xffBD7879), size: 15),
                      onPressed: () {
                        setState(() {
                          context.read<CartBloc>().add(RemoveItemFromCart(cartItem.itemName));
                          //cartManager.removeFromCart(cartItem.itemName);
                          '${cartItem.itemName} removed from cart!'.toast;
                        });
                      },
                    ),
                  ],
                ),
                subtitle: Text('Quantity: ${cartItem.quantity}'),
                trailing: Text('\$${(cartItem.itemPrice * cartItem.quantity).toStringAsFixed(2)}'),
              ),
            );
          },
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
            const Text('Subtotal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              '\$${cartManager.getTotalPrice().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // Text('\$${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          orderManager.createOrder(
            (order) {
              context.read<OrderBloc>().add(SaveOrderID(order.orderId));
              context.read<CartBloc>().add(const RemoveAllFromCart());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return OrderConfirmationScreen(
                      orderId: order.orderId,
                    );
                  },
                ),
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

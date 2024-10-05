import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wine_delivery_app/model/cart_item.dart';
import 'package:wine_delivery_app/utils/constants.dart';
import 'package:wine_delivery_app/utils/extensions.dart';
import 'package:wine_delivery_app/views/product/order/check_out_screen.dart';

import '../../../bloc/cart/cart_bloc.dart';
import '../../../bloc/navigation/bottom_navigation_bloc.dart';
import '../../../bloc/order/order_bloc.dart';
import '../../../bloc/promo_code/promo_code_bloc.dart';
import '../../../model/coupon.dart';
import '../../../model/order.dart';
import '../../../repository/coupon_repository.dart';
import '../../../utils/preferences.dart';
import '../../../utils/utils.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  @override
  void initState() {
    super.initState();
    promoCode = Constants.empty;
    context.read<CartBloc>().add(const GetCartItems());
    context.read<PromoCodeBloc>().add(InitPromoCode());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        if (state == const PageChanged(selectedIndex: 2)) {
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            appBar: AppBar(
              title: const Text('Shopping Cart'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
            ),
            body: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(child: CartItemsList()), // No need to pass cartItems
                  SubtotalSection(), // Pass state to SubtotalSection
                  PromoCodeInput(),
                  CheckoutButton(), // Pass state to CheckoutButton
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) => current is CartLoaded,
      builder: (context, state) {
        if (state is CartLoaded) {
          // context.read<CartBloc>().add(GetTotalPrice());
          if (state.cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty!'));
          }
          return ListView.builder(
            itemCount: state.cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = state.cartItems[index];
              return _buildCartCard(cartItem, context);
            },
          );
        } else {
          // return const Center(child: CircularProgressIndicator());

          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
              itemCount: 5, // Placeholder for loading items
              itemBuilder: (context, index) {
                return _buildShimmerCartCard();
              },
            ),
          );
        }
      },
    );
  }

  Card _buildShimmerCartCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          color: Colors.white,
        ),
        title: Container(
          height: 20,
          width: 100,
          color: Colors.white,
        ),
        subtitle: Container(
          height: 20,
          width: 50,
          color: Colors.white,
        ),
        trailing: Container(
          height: 20,
          width: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Card _buildCartCard(CartItem cartItem, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8).h,
      child: Container(
        height: 100.h,
        padding: const EdgeInsets.symmetric(horizontal: 14).w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 16,
              child: Row(
                children: [
                  // Product Image
                  ClipOval(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.grey.shade300,
                      child: Image.asset(
                        'assets/images/${cartItem.product!.image}',
                        width: 50.h,
                        height: 50.h,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  // Product Information and Actions
                  Flexible(
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cartItem.product!.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.r,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          // Product Price
                          SizedBox(height: 8.h),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            '\$${(cartItem.product!.price * cartItem.quantity!).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.r,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Increment Button
                  GestureDetector(
                    onTap: () {
                      context.read<CartBloc>().add(IncrementCartItem(itemId: cartItem.product!.id));
                    },
                    child: Container(
                      //padding: const EdgeInsets.all(4),
                      // width: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Color(0xff7D557A),
                        size: 20,
                      ),
                    ),
                  ),

                  // Quantity Display
                  Container(
                    // padding: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    width: 20.w,
                    child: Text(
                      '${cartItem.quantity}',
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.r,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Decrement Button
                  GestureDetector(
                    onTap: () {
                      context.read<CartBloc>().add(DecrementCartItem(itemId: cartItem.product!.id));
                    },
                    child: Container(
                      //padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Color(0xffBD7879),
                        size: 20,
                      ),
                    ),
                  ),

                  // Remove Button
                  /*GestureDetector(
                    onTap: () {
                      context.read<CartBloc>().add(RemoveFromCart(itemId: cartItem.product!.id));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(left: 6),
                      child: const Icon(
                        CupertinoIcons.delete,
                        color: Color(0xffBD7879),
                        size: 20,
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubtotalSection extends StatelessWidget {
  const SubtotalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) {
        return previous is CartLoaded && current is CartLoaded && previous.totalPrice != current.totalPrice;
      },
      builder: (context, state) {
        if (state is CartLoaded) {
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Subtotal',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '\$${state.totalPrice}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(width: MediaQuery.sizeOf(context).width, height: 50.h),
            ),
          );
          // return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class PromoCodeInput extends StatelessWidget {
  const PromoCodeInput({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    Coupon? promo;
    PromoCodeBloc promoCodeBloc = context.read<PromoCodeBloc>();
    CartBloc cartBloc = context.read<CartBloc>();

    loadCoupon(promoCodeBloc, cartBloc, controller.text);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 14.r),
        onChanged: (value) async {
          promo = await couponRepository.getCouponByCode(value);
          promoCode = promo?.code ?? '';
          loadCoupon(promoCodeBloc, cartBloc, controller.text);
        },
        decoration: InputDecoration(
          hintText: 'Enter promo code',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            icon: BlocBuilder<PromoCodeBloc, PromoCodeState>(
              builder: (context, state) {
                if (state is PromoCodeInitial) {
                  return const Icon(CupertinoIcons.xmark, color: Colors.red);
                } else {
                  return const Icon(CupertinoIcons.check_mark, color: Colors.green);
                }
              },
            ),
            onPressed: () {
              showBottomSheet(
                context: context,
                builder: (context) {
                  return ListTile(
                    title: Text('Coupon Discount Rate: ${promo?.discount ?? 'not available.'}'),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void loadCoupon(PromoCodeBloc promoCodeBloc, CartBloc cartBloc, String input) {
    if (promoCode != '' && input != '') {
      promoCodeBloc.add(UpdatePromoCode());
    } else {
      promoCodeBloc.add(InitPromoCode());
    }
    cartBloc.add(GetCartItems(couponCode: input));
  }
}

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: BlocListener<OrderBloc, OrderState>(
            listener: (context, orderState) {
              if (orderState is OrderCreated) {
                'Item(s) moved from cart!'.toast;
                //context.read<CartBloc>().add(const RemoveAllFromCart());

                // Navigate to the checkout page when order is successfully created
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CheckOutScreen(order: orderState.order);
                    },
                  ),
                );
              } else if (orderState is OrderError) {
                // Show error message if order creation failed
                logger.e(orderState.message);
                'Order creation failed! Please try again.'.toast;
              }
            },
            child: ElevatedButton(
              onPressed: () {
                if (cartState is CartLoaded) {
                  if (cartState.cartItems.isNotEmpty) {
                    context.read<OrderBloc>().add(
                          CreateOrder(
                            subTotal: cartState.totalPrice,
                            note: 'Coupon code for this purchase: ${cartState.couponCode}',
                          ),
                        );
                  } else {
                    'Cart is empty!'.toast;
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Text(
                  'Proceed to Checkout',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.r),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CheckoutPage extends StatelessWidget {
  final Order order;

  const CheckoutPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}'),
            Text('Total Price: \$${order.totalCost}'),
            // Add other order details and checkout functionality here
          ],
        ),
      ),
    );
  }
}

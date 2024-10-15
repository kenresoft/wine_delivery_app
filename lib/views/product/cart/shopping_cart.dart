import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../bloc/cart/cart_bloc.dart';
import '../../../bloc/order/order_bloc.dart';
import '../../../bloc/promo_code/promo_code_bloc.dart';
import '../../../model/cart_item.dart';
import '../../../model/coupon.dart';
import '../../../repository/coupon_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions.dart';
import '../../../utils/preferences.dart';
import '../order/check_out_screen.dart';
import 'quantity_button.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(child: CartItemsList()),
            const SubtotalSection(),
            const PromoCodeInput(),
            const CheckoutButton(),
          ],
        ),
      ),
    );
  }
}

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
        ),
        title: SizedBox(
          height: 20,
          width: 100,
        ),
        subtitle: SizedBox(
          height: 20,
          width: 50,
        ),
        trailing: SizedBox(
          height: 20,
          width: 40,
        ),
      ),
    );
  }

  Widget _buildCartCard(CartItem cartItem, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8).h,
      child: Dismissible(
        key: UniqueKey(),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text('Are you sure you want to remove this item from your cart?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
          }
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            context.read<CartBloc>().add(RemoveFromCart(itemId: cartItem.product!.id));
          }
        },
        background: Container(
          color: Theme.of(context).primaryColorDark,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete /*, color: Colors.white*/),
              SizedBox(width: 16.w),
            ],
          ),
        ),
        secondaryBackground: null,
        child: Container(
          height: 90,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8),
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
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),

                            // Product Price
                            SizedBox(height: 8.h),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              '\$${(cartItem.product!.price * cartItem.quantity!).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
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
                child: SizedBox(
                  width: 25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Increment Button
                      Flexible(
                        child: QuantityButton(
                          onPressed: () {
                            context.read<CartBloc>().add(IncrementCartItem(itemId: cartItem.product!.id));
                          },
                          icon: Icons.add,
                        ),
                      ),

                      // Quantity Display
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        alignment: Alignment.center,
                        child: Text(
                          '${cartItem.quantity}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Decrement Button
                      Flexible(
                        child: QuantityButton(
                          onPressed: () {
                            context.read<CartBloc>().add(DecrementCartItem(itemId: cartItem.product!.id));
                          },
                          icon: Icons.remove,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      /*buildWhen: (previous, current) {
        return previous is CartLoaded && current is CartLoaded && previous.totalPrice != current.totalPrice;
      },*/
      builder: (context, state) {
        if (state is CartLoaded) {
          return Card(
            elevation: 1,
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.symmetric(vertical: 4).h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
              margin: const EdgeInsets.symmetric(vertical: 8).h,
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

    return Container(
      height: 76.h,
      padding: const EdgeInsets.symmetric(vertical: 8.0).h,
      child: TextField(
        controller: controller,
        expands: true,
        maxLines: null,
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
                  return Icon(CupertinoIcons.xmark, color: Colors.red, size: 24.r);
                } else {
                  return Icon(CupertinoIcons.check_mark, color: Colors.green, size: 24.r);
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

class CheckoutButton extends StatefulWidget {
  const CheckoutButton({super.key});

  @override
  State<CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  bool hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0).h,
          child: ElevatedButton(
            onPressed: () {
              if (cartState is CartLoaded) {
                if (cartState.cartItems.isNotEmpty) {
                  context.read<OrderBloc>().add(
                        CreateOrder(
                          subTotal: cartState.totalPrice,
                          note: 'Coupon code for this purchase: ${cartState.couponCode}',
                          callback: (order) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CheckOutScreen(order: order),
                              ),
                            );
                          },
                        ),
                      );
                } else {
                  'Cart is empty!'.toasts;
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
        );
      },
    );
  }
}

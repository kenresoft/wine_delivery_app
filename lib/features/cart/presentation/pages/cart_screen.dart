import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/router/routes.dart';
import 'package:vintiora/core/theme/app_button_theme.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/features/cart/domain/entities/cart.dart';
import 'package:vintiora/features/cart/domain/entities/cart_item.dart';
import 'package:vintiora/features/cart/presentation/bloc/cart/cart_bloc.dart';
import 'package:vintiora/features/cart/presentation/widgets/cart_coupon_section.dart';
import 'package:vintiora/features/cart/presentation/widgets/cart_empty_view.dart';
import 'package:vintiora/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:vintiora/features/cart/presentation/widgets/cart_summary_card.dart';
import 'package:vintiora/features/main/presentation/bloc/navigation/bottom_navigation_bloc.dart';
import 'package:vintiora/features/main/presentation/widgets/custom_app_bar.dart';
import 'package:vintiora/shared/components/app_wrapper.dart';
import 'package:vintiora/shared/widgets/animated_fade_scale.dart';
import 'package:vintiora/shared/widgets/error_view.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch cart data when screen loads
    context.read<CartBloc>().add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      appBar: CustomAppBar(
        title: 'Shopping Cart',
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final cart = state.cart;
              if (cart == null || cart.items.isEmpty || state.itemCount == 0) return const SizedBox.shrink();
              return Badge(
                label: Text(state.itemCount.toString()),
                backgroundColor: AppColors.primary,
                alignment: Alignment(1.2, -1.2),
                child: const Icon(CupertinoIcons.shopping_cart),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.cart != null && state.cart!.items.isNotEmpty) {
            return _buildCheckoutButton(context, state.cart!);
          }
          return const SizedBox.shrink();
        },
      ),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state.status == CartStatus.error && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
          // Show success message for item removal
          if (state.itemRemoved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item removed from cart')),
            );
          }
        },
        builder: (context, state) {
          /*if (state.status == CartStatus.loading) {
            return const Center(child: AppLoader());
          }*/

          if (state.status == CartStatus.error) {
            return ErrorView(
              message: state.message ?? 'An error occurred',
              onRetry: () => context.read<CartBloc>().add(GetCartEvent()),
            );
          }

          final cart = state.cart;

          if (cart == null || cart.items.isEmpty) {
            return CartEmptyView(
              onShopNow: () => context.read<NavigationBloc>().add(PageTapped(0)),
            );
          }

          return _buildCartContent(context, cart);
        },
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, Cart cart) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCartItems(context, cart.items),
          const SizedBox(height: 24),
          CartCouponSection(
            onApplyCoupon: (couponCode) {
              context.read<CartBloc>().add(ApplyCouponEvent(couponCode: couponCode));
            },
            onRemoveCoupon: () {
              context.read<CartBloc>().add(RemoveCouponEvent());
            },
            hasDiscount: cart.pricing.discount > 0,
          ),
          const SizedBox(height: 24),
          CartSummaryCard(pricing: cart.pricing),
          const SizedBox(height: 80), // Space for bottom button
        ],
      ),
    );
  }

  Widget _buildCartItems(BuildContext context, List<CartItem> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        return AnimatedFadeScale(
          delay: Duration(milliseconds: 50 * index),
          child: CartItemCard(
            item: item,
            onIncrement: () {
              context.read<CartBloc>().add(IncrementCartItemEvent(itemId: item.product.id));
            },
            onDecrement: () {
              context.read<CartBloc>().add(DecrementCartItemEvent(itemId: item.product.id));
            },
            onRemove: () {
              context.read<CartBloc>().add(RemoveCartItemEvent(itemId: item.product.id));
            },
          ),
        );
      },
    );
  }

  Widget _buildCheckoutButton(BuildContext context, Cart cart) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to checkout - will be implemented separately
            Nav.push(Routes.checkout);
          },
          style: AppButtonTheme.defaultElevatedButton,
          child: Text(
            'Proceed to Checkout (${_formatPrice(cart.pricing.total)})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return '\$${(price / 1).toStringAsFixed(2)}';
  }
}

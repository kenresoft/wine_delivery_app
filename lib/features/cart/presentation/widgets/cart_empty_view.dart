import 'package:flutter/material.dart';
import 'package:vintiora/core/router/nav.dart';

/// A widget displayed when the user's shopping cart is empty.
///
/// This provides visual feedback and a call-to-action to encourage
/// the user to continue shopping.
class CartEmptyView extends StatelessWidget {
  /// Optional callback for the "Shop Now" button.
  /// If null, the button will navigate back by default.
  final VoidCallback? onShopNow;

  const CartEmptyView({
    super.key,
    this.onShopNow,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Looks like you haven\'t added any products to your cart yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onShopNow ?? () => Nav.pop(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Shop Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

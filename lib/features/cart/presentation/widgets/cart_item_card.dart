import 'package:flutter/material.dart';
import 'package:vintiora/__.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/cart/domain/entities/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final product = item.product;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppImage(
                _getImageUrl(product.image),
                width: 90,
                height: 90,
                fit: BoxFit.contain,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(width: 16),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatPrice(product.defaultPrice),
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Quantity controls
                  Row(
                    children: [
                      _buildQuantityControls(context),
                      const Spacer(),
                      _buildRemoveButton(context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Decrement button
          InkWell(
            onTap: item.quantity > 1 ? onDecrement : null,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: item.quantity > 1 ? Colors.grey.shade100 : Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
              ),
              child: Icon(
                Icons.remove,
                size: 18,
                color: item.quantity > 1 ? null : Colors.grey.shade400,
              ),
            ),
          ),

          // Quantity display
          Container(
            width: 40,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.shade300),
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Increment button
          InkWell(
            onTap: onIncrement,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: item.quantity < item.product.defaultQuantity ? Colors.grey.shade100 : Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
              ),
              child: Icon(
                Icons.add,
                size: 18,
                color: item.quantity < item.product.defaultQuantity ? null: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    return IconButton(
      onPressed: onRemove,
      icon: const Icon(Icons.delete_outline),
      color: Colors.red.shade400,
      tooltip: 'Remove from cart',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
      splashRadius: 24,
    );
  }

  String _formatPrice(double price) {
    return '\$${(price / 1).toStringAsFixed(2)}';
  }

  String _getImageUrl(String imagePath) {
    // Add base URL if the image path is relative
    if (imagePath.startsWith('/')) {
      return '${Constants.baseUrl}$imagePath';
    }
    return imagePath;
  }
}

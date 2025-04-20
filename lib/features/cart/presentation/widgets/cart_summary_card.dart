import 'package:flutter/material.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/features/cart/domain/entities/cart_pricing.dart';

class CartSummaryCard extends StatelessWidget {
  final CartPricing pricing;

  const CartSummaryCard({
    super.key,
    required this.pricing,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Subtotal row
            _buildSummaryRow(context, 'Subtotal', _formatPrice(pricing.subtotal)),

            // Show discount if applicable
            if (pricing.discount > 0) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                context,
                'Discount',
                '- ${_formatPrice(pricing.discount)}',
                valueColor: Colors.green.shade700,
              ),
            ],

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),

            // Total row
            _buildSummaryRow(
              context,
              'Total',
              _formatPrice(pricing.total),
              titleStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              valueStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String title,
    String value, {
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    Color? valueColor,
  }) {
    final defaultTitleStyle = Theme.of(context).textTheme.bodyMedium;
    final defaultValueStyle = Theme.of(context).textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titleStyle ?? defaultTitleStyle),
        Text(
          value,
          style: valueStyle ??
              defaultValueStyle?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return '\$${(price / 1).toStringAsFixed(2)}';
  }
}

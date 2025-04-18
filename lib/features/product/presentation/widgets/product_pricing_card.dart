import 'package:flutter/material.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/utils/currency_formatter.dart';
import 'package:vintiora/features/product/domain/entities/product_pricing.dart';

class ProductPricingCard extends StatelessWidget {
  final ProductPricing pricing;

  const ProductPricingCard({
    super.key,
    required this.pricing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceSection(context),
            if (pricing.hasDiscount) ...[
              const SizedBox(height: 16),
              _buildDiscountSection(context),
            ],
            if (pricing.activeFlashSale != null) ...[
              const SizedBox(height: 16),
              _buildFlashSaleSection(context),
            ],
            if (pricing.activePromotion != null) ...[
              const SizedBox(height: 16),
              _buildPromotionSection(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          CurrencyFormatter.formatPrice(pricing.bestPrice),
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        if (pricing.hasDiscount)
          Text(
            CurrencyFormatter.formatPrice(pricing.regularPrice),
            style: textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }

  Widget _buildDiscountSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.discount_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            pricing.discountPercentageFormatted,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'OFF',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSaleSection(BuildContext context) {
    final flashSale = pricing.activeFlashSale!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.flash_on, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              flashSale.title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              'Ends in: ${flashSale.timeRemainingFormatted.formatted}',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPromotionSection(BuildContext context) {
    final promotion = pricing.activePromotion!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.local_offer_outlined, color: AppColors.secondary),
            const SizedBox(width: 4),
            Text(
              promotion.title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                promotion.code,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _getDiscountText(promotion),
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getDiscountText(ActivePromotion promotion) {
    if (promotion.discountType == 'percentage') {
      return '${promotion.discountValue}% off';
    } else {
      return 'Save ${CurrencyFormatter.formatPrice(promotion.discountValue)}';
    }
  }
}

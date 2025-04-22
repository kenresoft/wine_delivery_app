import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/router/routes.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/core/utils/date_formatter.dart';
import 'package:vintiora/features/flash_sale/domain/entities/flash_sale.dart';

class FlashSaleProductCard extends StatelessWidget {
  final FlashSaleProduct flashSaleProduct;

  const FlashSaleProductCard({
    super.key,
    required this.flashSaleProduct,
  });

  @override
  Widget build(BuildContext context) {
    final product = flashSaleProduct.product;
    final hasDiscount = flashSaleProduct.product.currentFlashSale != null;
    final discountPercentage = hasDiscount ? ((1 - (flashSaleProduct.product.currentFlashSale!.specialPrice / flashSaleProduct.product.defaultPrice)) * 100) : 0;

    return GestureDetector(
      onTap: () => Nav.push(
        Routes.productDetails,
        arguments: product.id,
      ),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image placeholder
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 165,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: AppImage(
                    Constants.baseUrl + product.image,
                  ).toDecorationImage(
                    decorationFit: BoxFit.contain,
                  ),
                ),
                child: Center(
                  child: Text(
                    product.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Product brand
                    Text(
                      product.brand,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Price section
                    Row(
                      children: [
                        if (hasDiscount) ...[
                          Text(
                            DateFormat.formatPrice(flashSaleProduct.specialPrice),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          DateFormat.formatPrice(product.defaultPrice),
                          style: TextStyle(
                            fontSize: hasDiscount ? 14 : 16,
                            fontWeight: hasDiscount ? FontWeight.normal : FontWeight.bold,
                            decoration: hasDiscount ? TextDecoration.lineThrough : null,
                            color: hasDiscount ? Colors.grey : Colors.black,
                          ),
                        ),
                      ],
                    ),

                    if (hasDiscount) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Save: ${DateFormat.formatPrice(flashSaleProduct.savingsAmount)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${discountPercentage.toStringAsFixed(0)}% OFF',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

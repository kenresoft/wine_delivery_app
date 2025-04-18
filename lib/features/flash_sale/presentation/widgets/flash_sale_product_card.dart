import 'package:flutter/material.dart';
import 'package:vintiora/core/utils/date_formatter.dart';
import 'package:vintiora/features/flash_sale/domain/entities/flash_sale.dart';

import 'flash_sale_countdown_timer.dart';

class FlashSaleProductCard extends StatelessWidget {
  final FlashSale flashSale;
  final VoidCallback? onTap;

  const FlashSaleProductCard({
    super.key,
    required this.flashSale,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                child: Center(
                  child: Text(
                    flashSale.flashSaleProducts.first.product.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    flashSale.flashSaleProducts.first.product.name,
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
                    flashSale.flashSaleProducts.first.product.brand,
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
                      if (flashSale.flashSaleProducts.first.product.currentFlashSale != null) ...[
                        Text(
                          DateFormat.formatPrice(flashSale.flashSaleProducts.first.product.currentFlashSale!.specialPrice),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        DateFormat.formatPrice(flashSale.flashSaleProducts.first.product.defaultPrice),
                        style: TextStyle(
                          fontSize: flashSale.flashSaleProducts.first.product.currentFlashSale != null ? 14 : 16,
                          fontWeight: flashSale.flashSaleProducts.first.product.currentFlashSale != null ? FontWeight.normal : FontWeight.bold,
                          decoration: flashSale.flashSaleProducts.first.product.currentFlashSale != null ? TextDecoration.lineThrough : null,
                          color: flashSale.flashSaleProducts.first.product.currentFlashSale != null ? Colors.grey : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  if (flashSale.flashSaleProducts.first.product.currentFlashSale != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${flashSale.discountPercentage}% OFF',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],

                  if (flashSale.flashSaleProducts.first.product.currentFlashSale != null) ...[
                    const SizedBox(height: 12),
                    FlashSaleCountdownTimer(
                      hours: flashSale.timeRemainingFormatted.hours,
                      minutes: flashSale.timeRemainingFormatted.minutes,
                      seconds: flashSale.timeRemainingFormatted.seconds,
                      fontSize: 12,
                      showLabels: false,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

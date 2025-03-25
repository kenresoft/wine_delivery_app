import 'package:equatable/equatable.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';

class FlashSale extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int discountPercentage;
  final List<FlashSaleProduct> flashSaleProducts;
  final bool isActive;
  final int maxPurchaseQuantity;
  final double minPurchaseAmount;
  final int totalStock;
  final int stockRemaining;
  final int soldCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int timeRemaining;
  final TimeRemainingFormatted timeRemainingFormatted;
  final String status;

  const FlashSale({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.discountPercentage,
    required this.flashSaleProducts,
    required this.isActive,
    required this.maxPurchaseQuantity,
    required this.minPurchaseAmount,
    required this.totalStock,
    required this.stockRemaining,
    required this.soldCount,
    required this.createdAt,
    required this.updatedAt,
    required this.timeRemaining,
    required this.timeRemainingFormatted,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startDate,
        endDate,
        discountPercentage,
        flashSaleProducts,
        isActive,
        maxPurchaseQuantity,
        minPurchaseAmount,
        totalStock,
        stockRemaining,
        soldCount,
        createdAt,
        updatedAt,
        timeRemaining,
        timeRemainingFormatted,
        status,
      ];
}

class TimeRemainingFormatted extends Equatable {
  final int hours;
  final int minutes;
  final int seconds;
  final String formatted;

  const TimeRemainingFormatted({
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.formatted,
  });

  @override
  List<Object?> get props => [hours, minutes, seconds, formatted];
}

class FlashSaleProduct extends Equatable {
  final String id;
  final Product product;
  final double specialPrice;

  const FlashSaleProduct({
    required this.id,
    required this.product,
    required this.specialPrice,
  });

  double get discountPercentage {
    if (product.defaultPrice == 0) return 0;
    return ((product.defaultPrice - specialPrice) / product.defaultPrice * 100).roundToDouble();
  }

  double get savingsAmount {
    return product.defaultPrice - specialPrice;
  }

  @override
  List<Object?> get props => [id, product, specialPrice];
}

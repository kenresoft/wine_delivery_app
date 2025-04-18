import 'package:equatable/equatable.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';

class ActiveFlashSale extends Equatable {
  final String id;
  final String title;
  final DateTime endDate;
  final int timeRemaining;
  final TimeRemainingFormatted timeRemainingFormatted;

  const ActiveFlashSale({
    required this.id,
    required this.title,
    required this.endDate,
    required this.timeRemaining,
    required this.timeRemainingFormatted,
  });

  @override
  List<Object?> get props => [id, title, endDate, timeRemaining, timeRemainingFormatted];
}

class TimeRemainingFormatted extends Equatable {
  final String formatted;
  final int days;
  final int hours;
  final int minutes;

  const TimeRemainingFormatted({
    required this.formatted,
    required this.days,
    required this.hours,
    required this.minutes,
  });

  @override
  List<Object?> get props => [formatted, days, hours, minutes];
}

class ActivePromotion extends Equatable {
  final String id;
  final String title;
  final String code;
  final String discountType;
  final double discountValue;

  const ActivePromotion({
    required this.id,
    required this.title,
    required this.code,
    required this.discountType,
    required this.discountValue,
  });

  @override
  List<Object?> get props => [id, title, code, discountType, discountValue];
}

class ProductPricing extends Equatable {
  final double regularPrice;
  final double bestPrice;
  final double savingsAmount;
  final int savingsPercentage;
  final String priceType;
  final bool hasDiscount;
  final String discountPercentageFormatted;
  final ActivePromotion? activePromotion;
  final ActiveFlashSale? activeFlashSale;

  const ProductPricing({
    required this.regularPrice,
    required this.bestPrice,
    required this.savingsAmount,
    required this.savingsPercentage,
    required this.priceType,
    required this.hasDiscount,
    required this.discountPercentageFormatted,
    this.activePromotion,
    this.activeFlashSale,
  });

  @override
  List<Object?> get props => [
        regularPrice,
        bestPrice,
        savingsAmount,
        savingsPercentage,
        priceType,
        hasDiscount,
        discountPercentageFormatted,
        activePromotion,
        activeFlashSale,
      ];
}

// Extend the Product entity with pricing
class ProductWithPricing extends Equatable {
  final Product product;
  final ProductPricing pricing;

  const ProductWithPricing({
    required this.product,
    required this.pricing,
  });

  @override
  List<Object?> get props => [
        product,
        pricing,
      ];
}

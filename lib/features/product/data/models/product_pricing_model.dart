import 'package:vintiora/features/product/data/models/product_model.dart';
import 'package:vintiora/features/product/domain/entities/product_pricing.dart';

class TimeRemainingFormattedModel extends TimeRemainingFormatted {
  const TimeRemainingFormattedModel({
    required super.formatted,
    required super.days,
    required super.hours,
    required super.minutes,
  });

  factory TimeRemainingFormattedModel.fromJson(Map<String, dynamic> json) {
    return TimeRemainingFormattedModel(
      formatted: json['formatted'] as String,
      days: json['days'] as int,
      hours: json['hours'] as int,
      minutes: json['minutes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formatted': formatted,
      'days': days,
      'hours': hours,
      'minutes': minutes,
    };
  }
}

class ActiveFlashSaleModel extends ActiveFlashSale {
  const ActiveFlashSaleModel({
    required super.id,
    required super.title,
    required super.endDate,
    required super.timeRemaining,
    required super.timeRemainingFormatted,
  });

  factory ActiveFlashSaleModel.fromJson(Map<String, dynamic> json) {
    return ActiveFlashSaleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      endDate: DateTime.parse(json['endDate'] as String),
      timeRemaining: json['timeRemaining'] as int,
      timeRemainingFormatted: TimeRemainingFormattedModel.fromJson(
        json['timeRemainingFormatted'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'endDate': endDate.toIso8601String(),
      'timeRemaining': timeRemaining,
      'timeRemainingFormatted': (timeRemainingFormatted as TimeRemainingFormattedModel).toJson(),
    };
  }
}

class ActivePromotionModel extends ActivePromotion {
  const ActivePromotionModel({
    required super.id,
    required super.title,
    required super.code,
    required super.discountType,
    required super.discountValue,
  });

  factory ActivePromotionModel.fromJson(Map<String, dynamic> json) {
    return ActivePromotionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      code: json['code'] as String,
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'discountType': discountType,
      'discountValue': discountValue,
    };
  }
}

class ProductPricingModel extends ProductPricing {
  const ProductPricingModel({
    required super.regularPrice,
    required super.bestPrice,
    required super.savingsAmount,
    required super.savingsPercentage,
    required super.priceType,
    required super.hasDiscount,
    required super.discountPercentageFormatted,
    super.activePromotion,
    super.activeFlashSale,
  });

  factory ProductPricingModel.fromJson(Map<String, dynamic> json) {
    return ProductPricingModel(
      regularPrice: (json['regularPrice'] as num).toDouble(),
      bestPrice: (json['bestPrice'] as num).toDouble(),
      savingsAmount: (json['savingsAmount'] as num).toDouble(),
      savingsPercentage: json['savingsPercentage'] as int,
      priceType: json['priceType'] as String,
      hasDiscount: json['hasDiscount'] as bool,
      discountPercentageFormatted: json['discountPercentageFormatted'] as String,
      activePromotion: json['activePromotion'] != null ? ActivePromotionModel.fromJson(json['activePromotion'] as Map<String, dynamic>) : null,
      activeFlashSale: json['activeFlashSale'] != null ? ActiveFlashSaleModel.fromJson(json['activeFlashSale'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regularPrice': regularPrice,
      'bestPrice': bestPrice,
      'savingsAmount': savingsAmount,
      'savingsPercentage': savingsPercentage,
      'priceType': priceType,
      'hasDiscount': hasDiscount,
      'discountPercentageFormatted': discountPercentageFormatted,
      'activePromotion': activePromotion != null ? (activePromotion as ActivePromotionModel).toJson() : null,
      'activeFlashSale': activeFlashSale != null ? (activeFlashSale as ActiveFlashSaleModel).toJson() : null,
    };
  }
}

class ProductWithPricingModel extends ProductWithPricing {
  const ProductWithPricingModel({
    required super.product,
    required super.pricing,
  });

  factory ProductWithPricingModel.fromJson(Map<String, dynamic> json) {
    final productData = json;
    final pricingData = json['pricing'];

    // Remove pricing from product data before parsing
    productData.remove('pricing');

    return ProductWithPricingModel(
      product: ProductModel.fromJson(productData),
      pricing: ProductPricingModel.fromJson(pricingData),
    );
  }

  Map<String, dynamic> toJson() {
    final productJson = (product as ProductModel).toJson();
    final pricingJson = (pricing as ProductPricingModel).toJson();

    return {
      ...productJson,
      ...pricingJson,
    };
  }
}

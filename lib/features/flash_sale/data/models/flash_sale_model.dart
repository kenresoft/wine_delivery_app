import 'package:vintiora/features/flash_sale/domain/entities/flash_sale.dart';
import 'package:vintiora/features/product/data/models/product_model.dart';

class FlashSaleModel extends FlashSale {
  const FlashSaleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.discountPercentage,
    required super.flashSaleProducts,
    required super.isActive,
    required super.maxPurchaseQuantity,
    required super.minPurchaseAmount,
    required super.totalStock,
    required super.stockRemaining,
    required super.soldCount,
    required super.createdAt,
    required super.updatedAt,
    required super.timeRemaining,
    required super.timeRemainingFormatted,
    required super.status,
  });

  factory FlashSaleModel.fromJson(Map<String, dynamic> json) {
    final List<FlashSaleProduct> flashSaleProducts = [];
    if (json['flashSaleProducts'] != null) {
      for (var item in json['flashSaleProducts']) {
        flashSaleProducts.add(FlashSaleProductModel.fromJson(item));
      }
    }

    return FlashSaleModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      discountPercentage: json['discountPercentage'],
      flashSaleProducts: flashSaleProducts,
      isActive: json['isActive'],
      maxPurchaseQuantity: json['maxPurchaseQuantity'],
      minPurchaseAmount: json['minPurchaseAmount'] is int ? json['minPurchaseAmount'].toDouble() : json['minPurchaseAmount'],
      totalStock: json['totalStock'],
      stockRemaining: json['stockRemaining'],
      soldCount: json['soldCount'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      timeRemaining: json['timeRemaining'],
      timeRemainingFormatted: TimeRemainingFormattedModel.fromJson(json['timeRemainingFormatted']),
      status: json['status'] ?? (json['isActive'] ? 'active' : 'inactive'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'discountPercentage': discountPercentage,
      'flashSaleProducts': flashSaleProducts.map((flashSaleProduct) {
        if (flashSaleProduct is FlashSaleProductModel) {
          return flashSaleProduct.toFlashSaleJson();
        }
        return {};
      }).toList(),
      'isActive': isActive,
      'maxPurchaseQuantity': maxPurchaseQuantity,
      'minPurchaseAmount': minPurchaseAmount,
      'totalStock': totalStock,
      'stockRemaining': stockRemaining,
      'soldCount': soldCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'timeRemaining': timeRemaining,
      'timeRemainingFormatted': timeRemainingFormatted is TimeRemainingFormattedModel ? (timeRemainingFormatted as TimeRemainingFormattedModel).toJson() : {},
      'status': status,
    };
  }
}

class TimeRemainingFormattedModel extends TimeRemainingFormatted {
  const TimeRemainingFormattedModel({
    required super.hours,
    required super.minutes,
    required super.seconds,
    required super.formatted,
  });

  factory TimeRemainingFormattedModel.fromJson(Map<String, dynamic> json) {
    return TimeRemainingFormattedModel(
      hours: json['hours'],
      minutes: json['minutes'],
      seconds: json['seconds'],
      formatted: json['formatted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
      'formatted': formatted,
    };
  }
}

/// FlashSaleProductModel
class FlashSaleProductModel extends FlashSaleProduct {
  const FlashSaleProductModel({
    required super.id,
    required super.product,
    required super.specialPrice,
  });

  factory FlashSaleProductModel.fromJson(Map<String, dynamic> json) {
    return FlashSaleProductModel(
      id: json['_id'],
      product: ProductModel.fromFlashSaleJson(
        json['product'],
        json['specialPrice'] is num ? json['specialPrice'].toDouble() : null,
      ),
      specialPrice: json['specialPrice'] is num ? json['specialPrice'].toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toFlashSaleJson() {
    return {
      '_id': id,
      'product': (product is ProductModel) ? (product as ProductModel).toJson() : {},
      'specialPrice': specialPrice,
    };
  }
}

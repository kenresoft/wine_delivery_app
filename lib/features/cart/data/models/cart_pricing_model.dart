import 'package:vintiora/core/utils/utils.dart';
import 'package:vintiora/features/cart/domain/entities/cart_pricing.dart';

class CartPricingModel extends CartPricing {
  // final int subtotal;
  // final int discount;
  // final int total;
  // final String? id;

  const CartPricingModel({
    required super.subtotal,
    required super.discount,
    required super.total,
    super.id,
  });

  factory CartPricingModel.fromJson(Map<String, dynamic> json) {
    return CartPricingModel(
      subtotal: toDouble(json['subtotal']),
      discount: toDouble(json['discount']),
      total: toDouble(json['total']),
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      if (id != null) '_id': id,
    };
  }

  CartPricingModel copyWith({
    double? subtotal,
    double? discount,
    double? total,
    String? id,
  }) {
    return CartPricingModel(
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [subtotal, discount, total, id];
}

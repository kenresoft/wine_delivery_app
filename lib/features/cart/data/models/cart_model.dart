import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/features/cart/data/models/cart_item_model.dart';
import 'package:vintiora/features/cart/data/models/cart_pricing_model.dart';
import 'package:vintiora/features/cart/domain/entities/cart.dart';

class CartModel extends Cart {
  // final String id;
  // final String userId;
  // final List<CartItemModel> items;
  // final CartPricingModel pricing;
  // final DateTime updatedAt;
  // final DateTime createdAt;

  const CartModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.pricing,
    required super.updatedAt,
    required super.createdAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    try {
      final cart = CartModel(
        id: json['id'] ?? json['_id'],
        userId: json['user'],
        items: (json['items'] as List).map((item) => CartItemModel.fromJson(item)).toList(),
        pricing: CartPricingModel.fromJson(json['pricing']),
        updatedAt: DateTime.parse(json['updatedAt']),
        createdAt: DateTime.parse(json['createdAt']),
      );
      return cart;
    } catch (e, stack) {
      logger.e('Error loading cart: $e', stackTrace: stack);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'items': items.map((item) => (item as CartItemModel).toJson()).toList(),
      'pricing': (pricing as CartPricingModel).toJson(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  CartModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    CartPricingModel? pricing,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      pricing: pricing ?? this.pricing,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:vintiora/features/cart/domain/entities/cart_item.dart';
import 'package:vintiora/features/cart/domain/entities/cart_pricing.dart';

class Cart extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final CartPricing pricing;
  final DateTime updatedAt;
  final DateTime createdAt;

  const Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.pricing,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        pricing,
        updatedAt,
        createdAt,
      ];
}

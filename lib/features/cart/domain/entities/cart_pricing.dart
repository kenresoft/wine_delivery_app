import 'package:equatable/equatable.dart';

class CartPricing extends Equatable {
  final int subtotal;
  final int discount;
  final int total;
  final String? id;

  const CartPricing({
    required this.subtotal,
    required this.discount,
    required this.total,
    this.id,
  });

  @override
  List<Object?> get props => [subtotal, discount, total, id];
}
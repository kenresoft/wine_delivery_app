import 'package:equatable/equatable.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';

class CartItem extends Equatable {
  final String id;
  final Product product;
  final int quantity;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, product, quantity];
}
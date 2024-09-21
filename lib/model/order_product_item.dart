import 'package:equatable/equatable.dart';

import 'product.dart';

class OrderProductItem extends Equatable {
  final Product product;
  final int quantity;

  const OrderProductItem({
    required this.product,
    required this.quantity,
  });

  @override
  List<Object?> get props => [product, quantity];

  @override
  bool get stringify => true;
}
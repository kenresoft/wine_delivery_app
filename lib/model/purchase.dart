import 'package:equatable/equatable.dart';

import 'product.dart';

class Purchase extends Equatable {
  final String purchaseId;
  final Product product;
  final int quantity;
  final DateTime purchaseDate;

  const Purchase({
    required this.purchaseId,
    required this.product,
    required this.quantity,
    required this.purchaseDate,
  });

  factory Purchase.empty() {
    return Purchase(
      purchaseId: '',
      product: Product.empty(),
      quantity: 0,
      purchaseDate: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [purchaseId, product, quantity, purchaseDate];

  @override
  bool get stringify => true;
}

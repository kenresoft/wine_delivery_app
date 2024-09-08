part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();
}

class GetAllProducts extends ProductEvent {
  @override
  List<Object?> get props => [];
}

class GetProductsByIds extends ProductEvent {
  final List<String> productIds;

  const GetProductsByIds(this.productIds);

  @override
  List<Object?> get props => [productIds];
}

class GetProductById extends ProductEvent {
  final String productId;

  const GetProductById(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CreateProduct extends ProductEvent {
  final Product product;

  const CreateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProduct extends ProductEvent {
  final String productId;
  final Product product;

  const UpdateProduct({required this.productId, required this.product});

  @override
  List<Object?> get props => [productId, product];
}

class DeleteProduct extends ProductEvent {
  final String productId;

  const DeleteProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}
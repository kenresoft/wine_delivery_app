part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadAllProducts extends ProductEvent {
  const LoadAllProducts();
}

class LoadProductById extends ProductEvent {
  final String id;

  const LoadProductById(this.id);

  @override
  List<Object> get props => [id];
}

class LoadProductsByIds extends ProductEvent {
  final List<String> ids;

  const LoadProductsByIds(this.ids);

  @override
  List<Object> get props => [ids];
}

class LoadNewArrivals extends ProductEvent {
  const LoadNewArrivals();
}

class LoadPopularProducts extends ProductEvent {
  final int days;
  final int limit;

  const LoadPopularProducts({required this.days, required this.limit});

  @override
  List<Object> get props => [days, limit];
}

class LoadProductWithPricing extends ProductEvent {
  final String productId;

  const LoadProductWithPricing(this.productId);

  @override
  List<Object> get props => [productId];
}

class LoadRelatedProducts extends ProductEvent {
  final List<String> relatedProductIds;

  const LoadRelatedProducts(this.relatedProductIds);

  @override
  List<Object> get props => [relatedProductIds];
}
part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadAllProducts extends ProductEvent {}

class LoadProductById extends ProductEvent {
  final String id;

  const LoadProductById({required this.id});

  @override
  List<Object> get props => [id];
}

class LoadProductsByIds extends ProductEvent {
  final List<String> ids;

  const LoadProductsByIds({required this.ids});

  @override
  List<Object> get props => [ids];
}

class LoadNewArrivals extends ProductEvent {}

class LoadPopularProducts extends ProductEvent {
  final int days;
  final int limit;

  const LoadPopularProducts({required this.days, required this.limit});

  @override
  List<Object> get props => [days, limit];
}

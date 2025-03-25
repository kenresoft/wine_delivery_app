part of 'flash_sale_products_bloc.dart';

abstract class FlashSaleProductsState extends Equatable {
  const FlashSaleProductsState();

  @override
  List<Object> get props => [];
}

class FlashSaleProductsInitial extends FlashSaleProductsState {}

class FlashSaleProductsLoading extends FlashSaleProductsState {}

class FlashSaleProductsRefreshing extends FlashSaleProductsState {
  final List<FlashSaleProduct> products;

  const FlashSaleProductsRefreshing(this.products);

  @override
  List<Object> get props => [products];
}

class FlashSaleProductsLoaded extends FlashSaleProductsState {
  final List<FlashSaleProduct> products;

  const FlashSaleProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class FlashSaleProductsError extends FlashSaleProductsState {
  final String message;

  const FlashSaleProductsError(this.message);

  @override
  List<Object> get props => [message];
}

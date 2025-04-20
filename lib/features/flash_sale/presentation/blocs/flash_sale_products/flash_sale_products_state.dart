part of 'flash_sale_products_bloc.dart';

enum FlashSaleProductsStatus {
  initial,
  loading,
  refreshing,
  loaded,
  error,
}

class FlashSaleProductsState extends Equatable {
  final FlashSaleProductsStatus status;
  final List<FlashSaleProduct> products;
  final String? errorMessage;

  const FlashSaleProductsState({
    this.status = FlashSaleProductsStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  FlashSaleProductsState copyWith({
    FlashSaleProductsStatus? status,
    List<FlashSaleProduct>? products,
    String? errorMessage,
  }) {
    return FlashSaleProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}

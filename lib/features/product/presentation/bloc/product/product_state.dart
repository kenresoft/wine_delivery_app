part of 'product_bloc.dart';

enum ProductsStatus {
  initial,
  loading,
  loaded,
  detailLoaded,
  error,
}

class ProductState extends Equatable {
  final ProductsStatus status;
  final List<Product> products;
  final Product? selectedProduct;
  final List<Product>? newArrivals;
  final List<Product> popularProducts;
  final String? errorMessage;

  const ProductState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.newArrivals = const [],
    this.popularProducts = const [],
    this.errorMessage,
  });

  ProductState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    Product? selectedProduct,
    List<Product>? newArrivals,
    List<Product>? popularProducts,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      newArrivals: newArrivals ?? this.newArrivals,
      popularProducts: popularProducts ?? this.popularProducts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        selectedProduct,
        newArrivals,
        popularProducts,
        errorMessage,
      ];
}

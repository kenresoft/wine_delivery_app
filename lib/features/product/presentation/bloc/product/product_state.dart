part of 'product_bloc.dart';

enum ProductsStatus { initial, loading, loaded, detailLoaded, pricingLoaded, error }

class ProductState extends Equatable {
  final ProductsStatus status;
  final List<Product> products;
  final List<Product> newArrivals;
  final List<Product> popularProducts;
  final Product? selectedProduct;
  final ProductWithPricing? productWithPricing;
  final String? relatedProductsError;
  final String? errorMessage;
  final List<Product> relatedProducts; // Add this line

  const ProductState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.newArrivals = const [],
    this.popularProducts = const [],
    this.selectedProduct,
    this.productWithPricing,
    this.relatedProductsError,
    this.errorMessage,
    this.relatedProducts = const [], // Add this line
  });

  ProductState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    List<Product>? newArrivals,
    List<Product>? popularProducts,
    Product? selectedProduct,
    ProductWithPricing? productWithPricing,
    String? errorMessage,
    String? relatedProductsError,
    List<Product>? relatedProducts, // Add this line
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      newArrivals: newArrivals ?? this.newArrivals,
      popularProducts: popularProducts ?? this.popularProducts,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      productWithPricing: productWithPricing ?? this.productWithPricing,
      relatedProductsError: relatedProductsError ?? this.relatedProductsError,
      errorMessage: errorMessage ?? this.errorMessage,
      relatedProducts: relatedProducts ?? this.relatedProducts, // Add this line
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        newArrivals,
        popularProducts,
        selectedProduct,
        productWithPricing,
        errorMessage,
        relatedProducts, // Add this line
      ];
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/domain/entities/product_pricing.dart';
import 'package:vintiora/features/product/domain/usecases/get_all_products.dart';
import 'package:vintiora/features/product/domain/usecases/get_new_arrivals.dart';
import 'package:vintiora/features/product/domain/usecases/get_popular_products.dart';
import 'package:vintiora/features/product/domain/usecases/get_product_by_id.dart';
import 'package:vintiora/features/product/domain/usecases/get_product_with_pricing.dart';
import 'package:vintiora/features/product/domain/usecases/get_products_by_ids.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProducts;
  final GetProductById getProductById;
  final GetProductsByIds getProductsByIds;
  final GetNewArrivals getNewArrivals;
  final GetPopularProducts getPopularProducts;
  final GetProductWithPricing getProductWithPricing;

  ProductBloc({
    required this.getAllProducts,
    required this.getProductById,
    required this.getProductsByIds,
    required this.getNewArrivals,
    required this.getPopularProducts,
    required this.getProductWithPricing,
  }) : super(const ProductState()) {
    on<LoadAllProducts>(_onLoadAllProducts);
    on<LoadProductById>(_onLoadProductById);
    on<LoadProductsByIds>(_onLoadProductsByIds);
    on<LoadNewArrivals>(_onLoadNewArrivals);
    on<LoadPopularProducts>(_onLoadPopularProducts);
    on<LoadProductWithPricing>(_onLoadProductWithPricing);
    on<LoadRelatedProducts>(_onLoadRelatedProducts);
  }

  Future<void> _onLoadAllProducts(
    LoadAllProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductsStatus.loading));

    final result = await getAllProducts();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: ProductsStatus.loaded,
        products: products,
      )),
    );
  }

  Future<void> _onLoadProductById(
    LoadProductById event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductsStatus.loading));

    final result = await getProductById(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: failure.message,
      )),
      (product) => emit(state.copyWith(
        status: ProductsStatus.detailLoaded,
        selectedProduct: product,
      )),
    );
  }

  Future<void> _onLoadProductsByIds(
    LoadProductsByIds event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductsStatus.loading));

    final result = await getProductsByIds(event.ids);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: ProductsStatus.loaded,
        products: products,
      )),
    );
  }

  Future<void> _onLoadNewArrivals(
    LoadNewArrivals event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductsStatus.loading));

    final result = await getNewArrivals();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: ProductsStatus.loaded,
        newArrivals: products,
      )),
    );
  }

  Future<void> _onLoadPopularProducts(
    LoadPopularProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductsStatus.loading));

    final result = await getPopularProducts(event.days, event.limit);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: ProductsStatus.loaded,
        popularProducts: products,
      )),
    );
  }

  Future<void> _onLoadProductWithPricing(
    LoadProductWithPricing event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductsStatus.loading));

    final result = await getProductWithPricing(event.productId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: failure.message,
      )),
      (productWithPricing) async {
        emit(state.copyWith(
          status: ProductsStatus.pricingLoaded,
          productWithPricing: productWithPricing,
        ));

        if (productWithPricing.product.relatedProducts.isNotEmpty) {
          final relatedIds = productWithPricing.product.relatedProducts.map((rp) => rp.productId).toList();
          add(LoadRelatedProducts(relatedIds));
        }
      },
    );
  }

  Future<void> _onLoadRelatedProducts(
    LoadRelatedProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (event.relatedProductIds.isEmpty) {
      return emit(state.copyWith(relatedProducts: const []));
    }

    final relatedResult = await getProductsByIds(event.relatedProductIds);

    relatedResult.fold(
      (failure) => emit(state.copyWith(
        // Keep the main product but track related products error
        status: ProductsStatus.error,
        errorMessage: failure.message,
        // relatedProductsError: failure.message,
      )),
      (relatedProducts) => emit(state.copyWith(
        status: ProductsStatus.pricingLoaded,
        relatedProducts: relatedProducts,
      )),
    );
  }
}

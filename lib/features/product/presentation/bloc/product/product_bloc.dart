import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/domain/usecases/get_all_products.dart';
import 'package:vintiora/features/product/domain/usecases/get_new_arrivals.dart';
import 'package:vintiora/features/product/domain/usecases/get_popular_products.dart';
import 'package:vintiora/features/product/domain/usecases/get_product_by_id.dart';
import 'package:vintiora/features/product/domain/usecases/get_products_by_ids.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProducts;
  final GetProductById getProductById;
  final GetProductsByIds getProductsByIds;
  final GetNewArrivals getNewArrivals;
  final GetPopularProducts getPopularProducts;

  ProductBloc({
    required this.getAllProducts,
    required this.getProductById,
    required this.getProductsByIds,
    required this.getNewArrivals,
    required this.getPopularProducts,
  }) : super(const ProductState()) {
    on<LoadAllProducts>(_onLoadAllProducts);
    on<LoadProductById>(_onLoadProductById);
    on<LoadProductsByIds>(_onLoadProductsByIds);
    on<LoadNewArrivals>(_onLoadNewArrivals);
    on<LoadPopularProducts>(_onLoadPopularProducts);
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
}

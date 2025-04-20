import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/features/flash_sale/domain/entities/flash_sale.dart';
import 'package:vintiora/features/flash_sale/domain/repositories/flash_sale_repository.dart';

part 'flash_sale_products_event.dart';
part 'flash_sale_products_state.dart';

class FlashSaleProductsBloc extends Bloc<FlashSaleProductsEvent, FlashSaleProductsState> {
  final FlashSaleRepository repository;

  FlashSaleProductsBloc({required this.repository}) : super(const FlashSaleProductsState()) {
    on<LoadFlashSaleProducts>(_onLoadFlashSaleProducts);
    on<RefreshFlashSaleProducts>(_onRefreshFlashSaleProducts);
  }

  Future<void> _onLoadFlashSaleProducts(
    LoadFlashSaleProducts event,
    Emitter<FlashSaleProductsState> emit,
  ) async {
    emit(state.copyWith(status: FlashSaleProductsStatus.loading));

    final result = await repository.getFlashSaleProducts();

    result.fold(
      (failure) => emit(state.copyWith(
        status: FlashSaleProductsStatus.error,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: FlashSaleProductsStatus.loaded,
        products: products,
      )),
    );
  }

  Future<void> _onRefreshFlashSaleProducts(
    RefreshFlashSaleProducts event,
    Emitter<FlashSaleProductsState> emit,
  ) async {
    emit(state.copyWith(
      status: state.status == FlashSaleProductsStatus.loaded ? FlashSaleProductsStatus.refreshing : FlashSaleProductsStatus.loading,
    ));

    final result = await repository.getFlashSaleProducts();

    result.fold(
      (failure) => emit(state.copyWith(
        status: FlashSaleProductsStatus.error,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: FlashSaleProductsStatus.loaded,
        products: products,
      )),
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/features/flash_sale/domain/entities/flash_sale.dart';
import 'package:vintiora/features/flash_sale/domain/repositories/flash_sale_repository.dart';

part 'flash_sale_products_event.dart';
part 'flash_sale_products_state.dart';

class FlashSaleProductsBloc extends Bloc<FlashSaleProductsEvent, FlashSaleProductsState> {
  final FlashSaleRepository repository;

  FlashSaleProductsBloc({required this.repository}) : super(FlashSaleProductsInitial()) {
    on<LoadFlashSaleProducts>(_onLoadFlashSaleProducts);
    on<RefreshFlashSaleProducts>(_onRefreshFlashSaleProducts);
  }

  Future<void> _onLoadFlashSaleProducts(
    LoadFlashSaleProducts event,
    Emitter<FlashSaleProductsState> emit,
  ) async {
    emit(FlashSaleProductsLoading());

    final result = await repository.getFlashSaleProducts();

    result.fold(
      (failure) => emit(FlashSaleProductsError(failure.message)),
      (products) => emit(FlashSaleProductsLoaded(products)),
    );
  }

  Future<void> _onRefreshFlashSaleProducts(
    RefreshFlashSaleProducts event,
    Emitter<FlashSaleProductsState> emit,
  ) async {
    final currentState = state;

    if (currentState is FlashSaleProductsLoaded) {
      emit(FlashSaleProductsRefreshing(currentState.products));
    } else {
      emit(FlashSaleProductsLoading());
    }

    final result = await repository.getFlashSaleProducts();

    result.fold(
      (failure) => emit(FlashSaleProductsError(failure.message)),
      (products) => emit(FlashSaleProductsLoaded(products)),
    );
  }
}

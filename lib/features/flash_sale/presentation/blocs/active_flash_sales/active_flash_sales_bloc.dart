import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/flash_sale.dart';
import '../../../domain/repositories/flash_sale_repository.dart';

part 'active_flash_sales_event.dart';
part 'active_flash_sales_state.dart';

class ActiveFlashSalesBloc extends Bloc<ActiveFlashSalesEvent, ActiveFlashSalesState> {
  final FlashSaleRepository repository;

  ActiveFlashSalesBloc({required this.repository}) : super(const ActiveFlashSalesState()) {
    on<LoadActiveFlashSales>(_onLoadActiveFlashSales);
    on<RefreshActiveFlashSales>(_onRefreshActiveFlashSales);
  }

  Future<void> _onLoadActiveFlashSales(
    LoadActiveFlashSales event,
    Emitter<ActiveFlashSalesState> emit,
  ) async {
    emit(state.copyWith(status: ActiveFlashSalesStatus.loading));

    final result = await repository.getActiveFlashSales();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ActiveFlashSalesStatus.error,
        errorMessage: failure.message,
      )),
      (flashSales) => emit(state.copyWith(
        status: ActiveFlashSalesStatus.loaded,
        flashSales: flashSales,
      )),
    );
  }

  Future<void> _onRefreshActiveFlashSales(
    RefreshActiveFlashSales event,
    Emitter<ActiveFlashSalesState> emit,
  ) async {
    if (state.status == ActiveFlashSalesStatus.loaded) {
      emit(state.copyWith(status: ActiveFlashSalesStatus.refreshing));
    } else {
      emit(state.copyWith(status: ActiveFlashSalesStatus.loading));
    }

    final result = await repository.getActiveFlashSales();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ActiveFlashSalesStatus.error,
        errorMessage: failure.message,
      )),
      (flashSales) => emit(state.copyWith(
        status: ActiveFlashSalesStatus.loaded,
        flashSales: flashSales,
      )),
    );
  }
}

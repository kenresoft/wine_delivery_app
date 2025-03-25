import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/flash_sale.dart';
import '../../../domain/repositories/flash_sale_repository.dart';

part 'flash_sale_details_event.dart';
part 'flash_sale_details_state.dart';

class FlashSaleDetailsBloc
    extends Bloc<FlashSaleDetailsEvent, FlashSaleDetailsState> {
  final FlashSaleRepository repository;

  FlashSaleDetailsBloc({required this.repository})
      : super(const FlashSaleDetailsState()) {
    on<LoadFlashSaleDetails>(_onLoadFlashSaleDetails);
    on<RefreshFlashSaleDetails>(_onRefreshFlashSaleDetails);
  }

  Future<void> _onLoadFlashSaleDetails(
      LoadFlashSaleDetails event,
      Emitter<FlashSaleDetailsState> emit,
      ) async {
    emit(state.copyWith(status: FlashSaleDetailsStatus.loading));

    final result = await repository.getFlashSaleDetails(event.id);

    result.fold(
          (failure) => emit(state.copyWith(
        status: FlashSaleDetailsStatus.error,
        errorMessage: failure.message,
      )),
          (flashSale) => emit(state.copyWith(
        status: FlashSaleDetailsStatus.loaded,
        flashSale: flashSale,
      )),
    );
  }

  Future<void> _onRefreshFlashSaleDetails(
      RefreshFlashSaleDetails event,
      Emitter<FlashSaleDetailsState> emit,
      ) async {
    if (state.status == FlashSaleDetailsStatus.loaded) {
      emit(state.copyWith(status: FlashSaleDetailsStatus.refreshing));
    } else {
      emit(state.copyWith(status: FlashSaleDetailsStatus.loading));
    }

    final result = await repository.getFlashSaleDetails(event.id);

    result.fold(
          (failure) => emit(state.copyWith(
        status: FlashSaleDetailsStatus.error,
        errorMessage: failure.message,
      )),
          (flashSale) => emit(state.copyWith(
        status: FlashSaleDetailsStatus.loaded,
        flashSale: flashSale,
      )),
    );
  }
}
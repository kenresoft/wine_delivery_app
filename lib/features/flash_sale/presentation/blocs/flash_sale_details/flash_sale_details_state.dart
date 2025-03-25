part of 'flash_sale_details_bloc.dart';

enum FlashSaleDetailsStatus {
  initial,
  loading,
  refreshing,
  loaded,
  error,
}

class FlashSaleDetailsState extends Equatable {
  final FlashSaleDetailsStatus status;
  final FlashSale? flashSale;
  final String errorMessage;

  const FlashSaleDetailsState({
    this.status = FlashSaleDetailsStatus.initial,
    this.flashSale,
    this.errorMessage = '',
  });

  FlashSaleDetailsState copyWith({
    FlashSaleDetailsStatus? status,
    FlashSale? flashSale,
    String? errorMessage,
  }) {
    return FlashSaleDetailsState(
      status: status ?? this.status,
      flashSale: flashSale ?? this.flashSale,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, flashSale, errorMessage];
}
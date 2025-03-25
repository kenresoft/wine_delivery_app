part of 'active_flash_sales_bloc.dart';

enum ActiveFlashSalesStatus {
  initial,
  loading,
  refreshing,
  loaded,
  error,
}

class ActiveFlashSalesState extends Equatable {
  final ActiveFlashSalesStatus status;
  final List<FlashSale> flashSales;
  final String errorMessage;

  const ActiveFlashSalesState({
    this.status = ActiveFlashSalesStatus.initial,
    this.flashSales = const [],
    this.errorMessage = '',
  });

  ActiveFlashSalesState copyWith({
    ActiveFlashSalesStatus? status,
    List<FlashSale>? flashSales,
    String? errorMessage,
  }) {
    return ActiveFlashSalesState(
      status: status ?? this.status,
      flashSales: flashSales ?? this.flashSales,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, flashSales, errorMessage];
}
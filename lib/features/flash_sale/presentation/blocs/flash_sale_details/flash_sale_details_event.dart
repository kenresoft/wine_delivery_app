part of 'flash_sale_details_bloc.dart';

abstract class FlashSaleDetailsEvent extends Equatable {
  const FlashSaleDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadFlashSaleDetails extends FlashSaleDetailsEvent {
  final String id;

  const LoadFlashSaleDetails(this.id);

  @override
  List<Object> get props => [id];
}

class RefreshFlashSaleDetails extends FlashSaleDetailsEvent {
  final String id;

  const RefreshFlashSaleDetails(this.id);

  @override
  List<Object> get props => [id];
}
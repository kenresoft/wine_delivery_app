part of 'flash_sale_products_bloc.dart';

abstract class FlashSaleProductsEvent extends Equatable {
  const FlashSaleProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadFlashSaleProducts extends FlashSaleProductsEvent {}

class RefreshFlashSaleProducts extends FlashSaleProductsEvent {}
part of 'active_flash_sales_bloc.dart';

abstract class ActiveFlashSalesEvent extends Equatable {
  const ActiveFlashSalesEvent();

  @override
  List<Object> get props => [];
}

class LoadActiveFlashSales extends ActiveFlashSalesEvent {}

class RefreshActiveFlashSales extends ActiveFlashSalesEvent {}
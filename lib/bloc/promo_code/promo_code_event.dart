part of 'promo_code_bloc.dart';

sealed class PromoCodeEvent extends Equatable {
  const PromoCodeEvent();
}

final class InitPromoCode extends PromoCodeEvent {
  @override
  List<Object> get props => [];
}

final class UpdatePromoCode extends PromoCodeEvent {
  @override
  List<Object> get props => [];
}
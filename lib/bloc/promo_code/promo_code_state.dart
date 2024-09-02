part of 'promo_code_bloc.dart';

sealed class PromoCodeState extends Equatable {
  const PromoCodeState();
}

final class PromoCodeInitial extends PromoCodeState {
  @override
  List<Object> get props => [];
}

final class PromoCodeApplied extends PromoCodeState {
  @override
  List<Object> get props => [];
}

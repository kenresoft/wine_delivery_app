part of 'shipping_address_bloc.dart';

sealed class ShippingAddressState extends Equatable {
  const ShippingAddressState();
}

final class ShippingAddressLoading extends ShippingAddressState {
  @override
  List<Object> get props => [];
}

final class ShippingAddressLoaded extends ShippingAddressState {
  const ShippingAddressLoaded({required this.countriesState});

  final Map<String, List<String>> countriesState;

  @override
  List<Object> get props => [countriesState];
}

final class ShippingAddressError extends ShippingAddressState {
  @override
  List<Object> get props => [];
}

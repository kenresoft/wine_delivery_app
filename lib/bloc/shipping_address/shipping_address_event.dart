part of 'shipping_address_bloc.dart';

sealed class ShippingAddressEvent extends Equatable {
  const ShippingAddressEvent();
}

class ShippingAddressStarted extends ShippingAddressEvent {
  @override
  List<Object?> get props => [];

}

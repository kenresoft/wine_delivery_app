import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wine_delivery_app/repository/shipment_repository.dart';

part 'shipping_address_event.dart';
part 'shipping_address_state.dart';

class ShippingAddressBloc extends Bloc<ShippingAddressEvent, ShippingAddressState> {
  ShippingAddressBloc() : super(ShippingAddressLoading()) {
    on<ShippingAddressEvent>((event, emit) async {
      emit(ShippingAddressLoading());
      try {
        final countriesState = await shipmentRepository.loadCountriesWithStates();
        emit(ShippingAddressLoaded(countriesState: countriesState));
      } catch (e) {
        emit(ShippingAddressError());
      }
    });
  }
}

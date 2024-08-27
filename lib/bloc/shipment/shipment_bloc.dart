import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/model/shipment.dart';
import 'package:wine_delivery_app/repository/shipment_repository.dart';

part 'shipment_event.dart';

part 'shipment_state.dart';

class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  ShipmentBloc() : super(ShipmentInitial()) {
    on<SaveShipmentDetails>(saveShipmentDetails);

    on<GetShipmentDetails>(
      (event, emit) => getShipmentDetails(emit),
    );

    on<GetShipmentDetailsById>(
      (event, emit) {
        getShipmentDetailsById(emit, event.shipmentId);
      },
    );
  }

  void getShipmentDetails(Emitter<ShipmentState> emit) async {
    try {
      final shipments = await shipmentRepository.getShipmentDetails();
      emit(ShipmentLoaded(shipments));
    } catch (e) {
      emit(ShipmentError(e.toString()));
    }
  }

  Future<void> saveShipmentDetails(SaveShipmentDetails event, Emitter<ShipmentState> emit) async {
    try {
      final shipment = await shipmentRepository.saveShipmentDetails(
        country: event.country,
        state: event.state,
        city: event.city,
        company: event.company,
        address: event.address,
        apartment: event.apartment,
        fullName: event.fullName,
        zipCode: event.zipCode,
        note: event.note,
      );
      if (emit.isDone) {
        emit(ShipmentSaved(shipment));
      }
    } catch (e) {
      emit(ShipmentError(e.toString()));
    }
  }

  void getShipmentDetailsById(Emitter<ShipmentState> emit, String shipmentId) async {
    try {
      final shipment = await shipmentRepository.getShipmentDetailsById(shipmentId);
      emit(ShipmentFetched(shipment));
    } catch (e) {
      emit(ShipmentError(e.toString()));
    }
  }
}

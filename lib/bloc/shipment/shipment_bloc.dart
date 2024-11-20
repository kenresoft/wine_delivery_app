import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/model/shipment.dart';
import 'package:vintiora/repository/shipment_repository.dart';

part 'shipment_event.dart';
part 'shipment_state.dart';

class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  ShipmentBloc() : super(ShipmentInitial()) {
    on<SaveShipmentDetails>(saveShipmentDetails);
    on<GetShipmentDetails>(getShipmentDetails);
    on<GetShipmentDetailsById>(getShipmentDetailsById);
  }

  void getShipmentDetails(GetShipmentDetails event, Emitter<ShipmentState> emit) async {
    try {
      final shipment = await shipmentRepository.getShipmentDetails();
      if (shipment != null) {
        emit(ShipmentLoaded(shipment));
      } else {
        emit(ShipmentError('Shipment not available.'));
      }
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

  void getShipmentDetailsById(GetShipmentDetailsById event, Emitter<ShipmentState> emit) async {
    try {
      final shipment = await shipmentRepository.getShipmentDetailsById(event.shipmentId);
      emit(ShipmentFetched(shipment));
    } catch (e) {
      emit(ShipmentError(e.toString()));
    }
  }
}

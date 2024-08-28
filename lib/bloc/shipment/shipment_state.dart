part of 'shipment_bloc.dart';

sealed class ShipmentState extends Equatable {}

class ShipmentInitial extends ShipmentState {
  @override
  List<Object?> get props => [];
}

class ShipmentLoaded extends ShipmentState {
  final Shipment shipment;

  ShipmentLoaded(this.shipment);

  @override
  List<Object?> get props => [shipment];
}

class ShipmentSaved extends ShipmentState {
  final Shipment shipment;

  ShipmentSaved(this.shipment);

  @override
  List<Object?> get props => [shipment];
}

class ShipmentFetched extends ShipmentState {
  final Shipment shipment;

  ShipmentFetched(this.shipment);

  @override
  List<Object?> get props => [shipment];
}

class ShipmentError extends ShipmentState {
  final String message;

  ShipmentError(this.message);

  @override
  List<Object?> get props => [message];
}
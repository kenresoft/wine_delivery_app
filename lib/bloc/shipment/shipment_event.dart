part of 'shipment_bloc.dart';

sealed class ShipmentEvent extends Equatable {}

class GetShipmentDetails extends ShipmentEvent {
  @override
  List<Object?> get props => [];
}

class SaveShipmentDetails extends ShipmentEvent {
  final String country;
  final String state;
  final String city;
  final String company;
  final String address;
  final String apartment;
  final String fullName;
  final String zipCode;
  final String note;

  SaveShipmentDetails({
    required this.country,
    required this.state,
    required this.city,
    this.company = '',
    required this.address,
    this.apartment = '',
    required this.fullName,
    required this.zipCode,
    this.note = '',
  });

  @override
  List<Object?> get props => [country, state, city, company, address, apartment, fullName, zipCode, note];
}

class GetShipmentDetailsById extends ShipmentEvent {
  final String shipmentId;

  GetShipmentDetailsById(this.shipmentId);

  @override
  List<Object?> get props => [];
}
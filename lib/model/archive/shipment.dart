import 'package:equatable/equatable.dart';

class Shipment extends Equatable {
  final String? id;
  final String? user;
  final String? country;
  final String? state;
  final String? city;
  final String? company;
  final String? address;
  final String? apartment;
  final String? fullName;
  final String? zipCode;
  final String? note;

  const Shipment({
    this.id,
    this.user,
    this.country,
    this.state,
    this.city,
    this.company,
    this.address,
    this.apartment,
    this.fullName,
    this.zipCode,
    this.note,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      id: json['_id'],
      user: json['user'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
        company: json['company'],
        address: json['address'],
        apartment: json['apartment'],
        fullName: json['name'],
        zipCode: json['zip'],
        note: json['note'],
      );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'country': country,
      'state': state,
      'city': city,
      'company': company,
        'address': address,
        'apartment': apartment,
        'name': fullName,
        'zip': zipCode,
        'note': note,
      };
  }

  @override
  List<Object?> get props {
    return [
      id,
      user,
      country,
      state,
      city,
      company,
      address,
      apartment,
      fullName,
      zipCode,
      note,
    ];
  }

  @override
  bool get stringify => true;
}
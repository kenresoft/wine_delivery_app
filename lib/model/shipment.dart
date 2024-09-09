class Shipment {
  String? id;
  String? user;
  String? country;
  String? state;
  String? city;
  String? company;
  String? address;
  String? apartment;
  String? fullName;
  String? zipCode;
  String? note;

  Shipment({
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

  factory Shipment.fromJson(Map<String, dynamic> json) =>
      Shipment(
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

  Map<String, dynamic> toJson() =>
      {
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
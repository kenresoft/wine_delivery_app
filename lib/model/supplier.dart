import 'dart:convert';

Supplier supplierFromJson(String str) => Supplier.fromJson(json.decode(str));
String supplierToJson(Supplier data) => json.encode(data.toJson());
class Supplier {
  Supplier({
      this.id, 
      this.name, 
      this.contact, 
      this.location, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  Supplier.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    contact = json['contact'];
    location = json['location'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? name;
  String? contact;
  String? location;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['contact'] = contact;
    map['location'] = location;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}
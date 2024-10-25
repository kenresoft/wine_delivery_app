import 'dart:convert';

import '../utils/helpers.dart';
import 'supplier.dart';

Suppliers suppliersFromJson(String str) => Suppliers.fromJson(json.decode(str));

String suppliersToJson(Suppliers data) => json.encode(data.toJson());

class Suppliers {
  Suppliers({
    this.supplier,
    this.price,
    this.quantity,
    this.discount,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  Suppliers.fromJson(dynamic json) {
    supplier = json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null;
    price = toDouble(json['price']);
    quantity = json['quantity'];
    discount = toDouble(json['discount']);
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Supplier? supplier;
  double? price;
  int? quantity;
  double? discount;
  String? id;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (supplier != null) {
      map['supplier'] = supplier?.toJson();
    }
    map['price'] = price;
    map['quantity'] = quantity;
    map['discount'] = discount;
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

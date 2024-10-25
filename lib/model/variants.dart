import 'dart:convert';

Variants variantsFromJson(String str) => Variants.fromJson(json.decode(str));

String variantsToJson(Variants data) => json.encode(data.toJson());

class Variants {
  Variants({
    this.type,
    this.value,
    this.id,
  });

  Variants.fromJson(dynamic json) {
    type = json['type'];
    value = json['value'];
    id = json['_id'];
  }

  String? type;
  String? value;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['value'] = value;
    map['_id'] = id;
    return map;
  }
}

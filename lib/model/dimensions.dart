import 'dart:convert';

import '../utils/helpers.dart';

Dimensions dimensionsFromJson(String str) => Dimensions.fromJson(json.decode(str));

String dimensionsToJson(Dimensions data) => json.encode(data.toJson());

class Dimensions {
  Dimensions({
    this.height,
    this.length,
    this.width,
  });

  Dimensions.fromJson(dynamic json) {
    height = toDouble(json['height']);
    length = toDouble(json['length']);
    width = toDouble(json['width']);
  }

  double? height;
  double? length;
  double? width;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['length'] = length;
    map['width'] = width;
    return map;
  }
}

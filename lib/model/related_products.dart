import 'dart:convert';

RelatedProducts relatedProductsFromJson(String str) => RelatedProducts.fromJson(json.decode(str));
String relatedProductsToJson(RelatedProducts data) => json.encode(data.toJson());
class RelatedProducts {
  RelatedProducts({
      this.product, 
      this.matchedFields, 
      this.relationshipType, 
      this.priority, 
      this.id,});

  RelatedProducts.fromJson(dynamic json) {
    product = json['product'];
    matchedFields = json['matchedFields'] != null ? json['matchedFields'].cast<String>() : [];
    relationshipType = json['relationshipType'];
    priority = json['priority'];
    id = json['_id'];
  }
  String? product;
  List<String>? matchedFields;
  String? relationshipType;
  int? priority;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product'] = product;
    map['matchedFields'] = matchedFields;
    map['relationshipType'] = relationshipType;
    map['priority'] = priority;
    map['_id'] = id;
    return map;
  }

}
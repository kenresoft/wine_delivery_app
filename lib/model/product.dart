import 'dart:convert';

import '../utils/helpers.dart';
import 'category.dart';
import 'dimensions.dart';
import 'related_products.dart';
import 'reviews.dart';
import 'suppliers.dart';
import 'variants.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.dimensions,
    this.id,
    this.name,
    this.category,
    this.image,
    this.defaultPrice,
    this.defaultQuantity,
    this.defaultDiscount,
    this.suppliers,
    this.alcoholContent,
    this.description,
    this.deleted,
    this.tags,
    this.stockStatus,
    this.isFeatured,
    this.isOnSale,
    this.variants,
    this.shippingCost,
    this.relatedProducts,
    this.reviews,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.isNewArrival,
    this.brand,
    this.weight,
    this.images,
  });

  Product.fromJson(dynamic json) {
    dimensions = json['dimensions'] != null ? Dimensions.fromJson(json['dimensions']) : null;
    id = json['_id'];
    name = json['name'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    image = json['image'];

    // Safely convert 'defaultPrice' to double if it's an int or already a double
    defaultPrice = toDouble(json['defaultPrice']);
    defaultQuantity = json['defaultQuantity'];

    // Safely convert 'defaultDiscount' to double if it's an int or already a double
    defaultDiscount = toDouble(json['defaultDiscount']);

    // Handle suppliers list if it exists
    if (json['suppliers'] != null) {
      suppliers = [];
      json['suppliers'].forEach((v) {
        suppliers?.add(Suppliers.fromJson(v));
      });
    }

    // Safely convert 'alcoholContent' to double if it's an int or already a double
    alcoholContent = toDouble(json['alcoholContent']);

    description = json['description'];
    deleted = json['deleted'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    stockStatus = json['stockStatus'];
    isFeatured = json['isFeatured'];
    isOnSale = json['isOnSale'];

    // Handle variants list if it exists
    if (json['variants'] != null) {
      variants = [];
      json['variants'].forEach((v) {
        variants?.add(Variants.fromJson(v));
      });
    }

    // Safely convert 'shippingCost' to double if it's an int or already a double
    shippingCost = toDouble(json['shippingCost']);

    // Handle related products list if it exists
    if (json['relatedProducts'] != null) {
      relatedProducts = [];
      json['relatedProducts'].forEach((v) {
        relatedProducts?.add(RelatedProducts.fromJson(v));
      });
    }

    // Handle reviews list if it exists
    if (json['reviews'] != null) {
      reviews = [];
      json['reviews'].forEach((v) {
        reviews?.add(Reviews.fromJson(v));
      });
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['version'];
    isNewArrival = json['isNewArrival'];
    brand = json['brand'];

    // Safely convert 'weight' to double if it's an int or already a double
    weight = toDouble(json['weight']);
    images = json['images'] != null ? json['images'].cast<String>() : [];
  }

  Dimensions? dimensions;
  String? id;
  String? name;
  Category? category;
  String? image;
  double? defaultPrice;
  int? defaultQuantity;
  double? defaultDiscount;
  List<Suppliers>? suppliers;
  double? alcoholContent;
  String? description;
  bool? deleted;
  List<String>? tags;
  String? stockStatus;
  bool? isFeatured;
  bool? isOnSale;
  List<Variants>? variants;
  double? shippingCost;
  List<RelatedProducts>? relatedProducts;
  List<Reviews>? reviews;
  String? createdAt;
  String? updatedAt;
  int? version;
  bool? isNewArrival;
  String? brand;
  double? weight;
  List<String>? images;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (dimensions != null) {
      map['dimensions'] = dimensions?.toJson();
    }
    map['_id'] = id;
    map['name'] = name;
    if (category != null) {
      map['category'] = category?.toJson();
    }
    map['image'] = image;
    map['defaultPrice'] = defaultPrice;
    map['defaultQuantity'] = defaultQuantity;
    map['defaultDiscount'] = defaultDiscount;
    if (suppliers != null) {
      map['suppliers'] = suppliers?.map((v) => v.toJson()).toList();
    }
    map['alcoholContent'] = alcoholContent;
    map['description'] = description;
    map['deleted'] = deleted;
    map['tags'] = tags;
    map['stockStatus'] = stockStatus;
    map['isFeatured'] = isFeatured;
    map['isOnSale'] = isOnSale;
    if (variants != null) {
      map['variants'] = variants?.map((v) => v.toJson()).toList();
    }
    map['shippingCost'] = shippingCost;
    if (relatedProducts != null) {
      map['relatedProducts'] = relatedProducts?.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      map['reviews'] = reviews?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['version'] = version;
    map['isNewArrival'] = isNewArrival;
    map['brand'] = brand;
    map['weight'] = weight;
    map['images'] = images;
    return map;
  }
}

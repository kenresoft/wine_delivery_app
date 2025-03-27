import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Product extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String description;
  final ProductCategory category;
  final double defaultPrice;
  final int defaultQuantity;
  final double defaultDiscount;
  final List<ProductSupplier> suppliers;
  final double alcoholContent;
  final List<String> tags;
  final List<String> images;
  final String? image;
  final Dimensions dimensions;
  final CurrentFlashSale? currentFlashSale;
  final List<ProductReview> reviews;
  final List<RelatedProduct> relatedProducts;
  final bool isNewArrival;
  final bool isFeatured;
  final bool isOnSale;
  final String stockStatus;
  final double shippingCost;
  final double weight;
  final bool deleted;
  final List<ProductVariant> variants;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  const Product({
    required this.id,
    required this.name,
    this.brand = 'Generic Brand',
    this.description = 'No description',
    required this.category,
    this.defaultPrice = 0.0,
    this.defaultQuantity = 0,
    this.defaultDiscount = 0.0,
    this.suppliers = const [],
    this.alcoholContent = 0.0,
    this.tags = const [],
    this.images = const [],
    this.image,
    this.dimensions = const Dimensions(),
    this.currentFlashSale,
    this.reviews = const [],
    this.relatedProducts = const [],
    this.isNewArrival = false,
    this.isFeatured = false,
    this.isOnSale = false,
    this.stockStatus = 'Out of Stock',
    this.shippingCost = 0.0,
    this.weight = 0.0,
    this.deleted = false,
    this.variants = const [],
    required this.createdAt,
    required this.updatedAt,
    this.version = 0,
  });

  factory Product.empty() {
    return Product(
      id: '',
      name: '',
      category: const ProductCategory(id: '', name: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    String? description,
    ProductCategory? category,
    double? defaultPrice,
    int? defaultQuantity,
    double? defaultDiscount,
    List<ProductSupplier>? suppliers,
    double? alcoholContent,
    List<String>? tags,
    List<String>? images,
    String? image,
    Dimensions? dimensions,
    CurrentFlashSale? currentFlashSale,
    List<ProductReview>? reviews,
    List<RelatedProduct>? relatedProducts,
    bool? isNewArrival,
    bool? isFeatured,
    bool? isOnSale,
    String? stockStatus,
    double? shippingCost,
    double? weight,
    bool? deleted,
    List<ProductVariant>? variants,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      category: category ?? this.category,
      defaultPrice: defaultPrice ?? this.defaultPrice,
      defaultQuantity: defaultQuantity ?? this.defaultQuantity,
      defaultDiscount: defaultDiscount ?? this.defaultDiscount,
      suppliers: suppliers ?? this.suppliers,
      alcoholContent: alcoholContent ?? this.alcoholContent,
      tags: tags ?? this.tags,
      images: images ?? this.images,
      image: image ?? this.image,
      dimensions: dimensions ?? this.dimensions,
      currentFlashSale: currentFlashSale ?? this.currentFlashSale,
      reviews: reviews ?? this.reviews,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      isFeatured: isFeatured ?? this.isFeatured,
      isOnSale: isOnSale ?? this.isOnSale,
      stockStatus: stockStatus ?? this.stockStatus,
      shippingCost: shippingCost ?? this.shippingCost,
      weight: weight ?? this.weight,
      deleted: deleted ?? this.deleted,
      variants: variants ?? this.variants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        description,
        category,
        defaultPrice,
        defaultQuantity,
        defaultDiscount,
        suppliers,
        alcoholContent,
        tags,
        images,
        image,
        dimensions,
        currentFlashSale,
        reviews,
        relatedProducts,
        isNewArrival,
        isFeatured,
        isOnSale,
        stockStatus,
        shippingCost,
        weight,
        deleted,
        variants,
        createdAt,
        updatedAt,
        version
      ];
}

// Supporting model classes
@immutable
class ProductCategory extends Equatable {
  final String id;
  final String name;
  final int version;

  const ProductCategory({required this.id, required this.name, this.version = 0});

  @override
  List<Object?> get props => [id, name, version];
}

@immutable
class ProductSupplier extends Equatable {
  final String id;
  final Map<String, dynamic> supplier;
  final double price;
  final int quantity;
  final double discount;

  const ProductSupplier({
    required this.id,
    required this.supplier,
    this.price = 0.0,
    this.quantity = 0,
    this.discount = 0.0,
  });

  @override
  List<Object?> get props => [id, supplier, price, quantity, discount];
}

@immutable
class Dimensions extends Equatable {
  final double length;
  final double width;
  final double height;

  const Dimensions({this.length = 0.0, this.width = 0.0, this.height = 0.0});

  @override
  List<Object?> get props => [length, width, height];
}

@immutable
class CurrentFlashSale extends Equatable {
  final String? flashSaleId;
  final double specialPrice;
  final DateTime startDate;
  final DateTime endDate;

  const CurrentFlashSale({
    this.flashSaleId,
    required this.specialPrice,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [flashSaleId, specialPrice, startDate, endDate];
}

@immutable
class ProductReview extends Equatable {
  final String? userId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductReview({
    this.userId,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [userId, rating, comment, createdAt, updatedAt];
}

@immutable
class RelatedProduct extends Equatable {
  final String productId;
  final List<String> matchedFields;
  final String relationshipType;
  final int priority;

  const RelatedProduct({
    required this.productId,
    this.matchedFields = const [],
    this.relationshipType = 'related',
    this.priority = 1,
  });

  @override
  List<Object?> get props => [productId, matchedFields, relationshipType, priority];
}

@immutable
class ProductVariant extends Equatable {
  final String type;
  final String value;
  final String? id;

  const ProductVariant({
    required this.type,
    required this.value,
    this.id,
  });

  @override
  List<Object?> get props => [type, value, id];
}

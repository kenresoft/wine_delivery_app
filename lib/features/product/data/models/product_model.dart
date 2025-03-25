import 'package:vintiora/features/product/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required String id,
    required String name,
    required CategoryModel category,
    required double defaultPrice,
    required int defaultQuantity,
    required double defaultDiscount,
    required List<SupplierModel> suppliers,
    required double alcoholContent,
    required String description,
    required bool deleted,
    required List<String> tags,
    required String stockStatus,
    required bool isFeatured,
    required bool isOnSale,
    required List<VariantModel> variants,
    required double shippingCost,
    required List<RelatedProductModel> relatedProducts,
    required List<ReviewModel> reviews,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
    required bool isNewArrival,
    required String brand,
    required double weight,
    required List<String> images,
    String? image,
    required DimensionsModel dimensions,
    CurrentFlashSaleModel? currentFlashSale,
  }) : super(
          id: id,
          name: name,
          category: category,
          defaultPrice: defaultPrice,
          defaultQuantity: defaultQuantity,
          defaultDiscount: defaultDiscount,
          suppliers: suppliers,
          alcoholContent: alcoholContent,
          description: description,
          deleted: deleted,
          tags: tags,
          stockStatus: stockStatus,
          isFeatured: isFeatured,
          isOnSale: isOnSale,
          variants: variants,
          shippingCost: shippingCost,
          relatedProducts: relatedProducts,
          reviews: reviews,
          createdAt: createdAt,
          updatedAt: updatedAt,
          version: version,
          isNewArrival: isNewArrival,
          brand: brand,
          weight: weight,
          images: images,
          image: image,
          dimensions: dimensions,
          currentFlashSale: currentFlashSale,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    CurrentFlashSaleModel? currentFlashSale;
    if (json['currentFlashSale'] != null) {
      currentFlashSale = CurrentFlashSaleModel.fromJson(json['currentFlashSale']);
    }

    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unnamed Product',
      brand: json['brand'] ?? 'Generic Brand',
      description: json['description'],
      category: CategoryModel.fromJson(json['category'] ?? {}),
      defaultPrice: (json['defaultPrice'] ?? 0.0).toDouble(),
      defaultQuantity: json['defaultQuantity'] ?? 0,
      defaultDiscount: (json['defaultDiscount'] ?? 0.0).toDouble(),
      suppliers: (json['suppliers'] as List<dynamic>?)?.map((s) => SupplierModel.fromJson(s)).toList() ?? [],
      alcoholContent: (json['alcoholContent'] ?? 0.0).toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      image: json['image'],
      dimensions: DimensionsModel.fromJson(json['dimensions'] ?? {}),
      currentFlashSale: currentFlashSale,
      reviews: (json['reviews'] as List<dynamic>?)?.map((r) => ReviewModel.fromJson(r)).toList() ?? [],
      relatedProducts: (json['relatedProducts'] as List<dynamic>?)?.map((rp) => RelatedProductModel.fromJson(rp)).toList() ?? [],
      isNewArrival: json['isNewArrival'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      isOnSale: json['isOnSale'] ?? false,
      stockStatus: json['stockStatus'] ?? 'Out of Stock',
      shippingCost: (json['shippingCost'] ?? 0.0).toDouble(),
      weight: (json['weight'] ?? 0.0).toDouble(),
      deleted: json['deleted'] ?? false,
      variants: (json['variants'] as List<dynamic>?)?.map((v) => VariantModel.fromJson(v)).toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      version: json['version'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'brand': brand,
      'description': description,
      'category': (category as CategoryModel).toJson(),
      'defaultPrice': defaultPrice,
      'defaultQuantity': defaultQuantity,
      'defaultDiscount': defaultDiscount,
      'suppliers': suppliers.map((s) => (s as SupplierModel).toJson()).toList(),
      'alcoholContent': alcoholContent,
      'tags': tags,
      'images': images,
      'image': image,
      'dimensions': (dimensions as DimensionsModel).toJson(),
      'currentFlashSale': (currentFlashSale as CurrentFlashSaleModel).toJson(),
      'reviews': reviews.map((r) => (r as ReviewModel).toJson()).toList(),
      'relatedProducts': relatedProducts.map((rp) => (rp as RelatedProductModel).toJson()).toList(),
      'isNewArrival': isNewArrival,
      'isFeatured': isFeatured,
      'isOnSale': isOnSale,
      'stockStatus': stockStatus,
      'shippingCost': shippingCost,
      'weight': weight,
      'deleted': deleted,
      'variants': variants.map((v) => (v as VariantModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'version': version,
    };
  }

// ... Rest of the model code remains the same ...
}

// Supporting model classes with serialization
class CategoryModel extends ProductCategory {
  const CategoryModel({required super.id, required super.name, super.version});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Uncategorized',
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      '__v': version,
    };
  }
}

// Implement similar serialization for other model classes
// (SupplierModel, DimensionsModel, CurrentFlashSaleModel, etc.)
// following the same pattern as CategoryModel

class SupplierModel extends ProductSupplier {
  const SupplierModel({
    required String id,
    required Map<String, dynamic> supplier,
    double price = 0.0,
    int quantity = 0,
    double discount = 0.0,
  }) : super(
          id: id,
          supplier: supplier,
          price: price,
          quantity: quantity,
          discount: discount,
        );

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['_id'] ?? '',
      supplier: json['supplier'] ?? {},
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      discount: (json['discount'] ?? 0.0).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'supplier': supplier,
      'price': price,
      'quantity': quantity,
      'discount': discount,
    };
  }
}

class DimensionsModel extends Dimensions {
  const DimensionsModel({
    double length = 0.0,
    double width = 0.0,
    double height = 0.0,
  }) : super(length: length, width: width, height: height);

  factory DimensionsModel.fromJson(Map<String, dynamic> json) {
    return DimensionsModel(
      length: (json['length'] ?? 0.0).toDouble(),
      width: (json['width'] ?? 0.0).toDouble(),
      height: (json['height'] ?? 0.0).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'width': width,
      'height': height,
    };
  }
}

class CurrentFlashSaleModel extends CurrentFlashSale {
  const CurrentFlashSaleModel({
    String? flashSaleId,
    required double specialPrice,
    required DateTime startDate,
    required DateTime endDate,
  }) : super(
          flashSaleId: flashSaleId,
          specialPrice: specialPrice,
          startDate: startDate,
          endDate: endDate,
        );

  factory CurrentFlashSaleModel.fromJson(Map<String, dynamic> json) {
    return CurrentFlashSaleModel(
      flashSaleId: json['flashSale'],
      specialPrice: (json['specialPrice'] ?? 0.0).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'flashSale': flashSaleId,
      'specialPrice': specialPrice,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}

class ReviewModel extends ProductReview {
  const ReviewModel({
    String? userId,
    required int rating,
    String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          userId: userId,
          rating: rating,
          comment: comment,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userId: json['user'],
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class RelatedProductModel extends RelatedProduct {
  const RelatedProductModel({
    required String productId,
    List<String> matchedFields = const [],
    String relationshipType = 'related',
    int priority = 1,
  }) : super(
          productId: productId,
          matchedFields: matchedFields,
          relationshipType: relationshipType,
          priority: priority,
        );

  factory RelatedProductModel.fromJson(Map<String, dynamic> json) {
    return RelatedProductModel(
      productId: json['product'] ?? '',
      matchedFields: List<String>.from(json['matchedFields'] ?? []),
      relationshipType: json['relationshipType'] ?? 'related',
      priority: json['priority'] ?? 1,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'product': productId,
      'matchedFields': matchedFields,
      'relationshipType': relationshipType,
      'priority': priority,
    };
  }
}

class VariantModel extends ProductVariant {
  const VariantModel({
    required String type,
    required String value,
    String? id,
  }) : super(
          type: type,
          value: value,
          id: id,
        );

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      type: json['type'] ?? '',
      value: json['value'] ?? '',
      id: json['_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      '_id': id,
    };
  }
}

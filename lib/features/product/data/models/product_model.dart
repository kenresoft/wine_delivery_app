import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required CategoryModel super.category,
    required super.defaultPrice,
    required super.defaultQuantity,
    required super.defaultDiscount,
    required super.suppliers,
    required super.alcoholContent,
    required super.description,
    required super.deleted,
    required super.tags,
    required super.stockStatus,
    required super.isFeatured,
    required super.isOnSale,
    required List<VariantModel> super.variants,
    required super.shippingCost,
    required List<RelatedProductModel> super.relatedProducts,
    required List<ReviewModel> super.reviews,
    required super.createdAt,
    required super.updatedAt,
    required super.version,
    required super.isNewArrival,
    required super.brand,
    required super.weight,
    required super.images,
    super.image,
    required DimensionsModel super.dimensions,
    super.currentFlashSale,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    CurrentFlashSaleModel? currentFlashSale;
    if (json['currentFlashSale'] != null) {
      currentFlashSale = CurrentFlashSaleModel.fromJson(json['currentFlashSale']);
    }

    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unnamed Product',
      brand: json['brand'] ?? 'Generic Brand',
      description: json['description'] ?? 'No description',
      // If the category is provided as a Map, use it; otherwise, create a default category.
      category: json['category'] is Map<String, dynamic> ? CategoryModel.fromJson(json['category']) : CategoryModel(id: json['category'] ?? '', name: 'Unknown Category'),
      defaultPrice: (json['defaultPrice'] ?? 0.0).toDouble(),
      defaultQuantity: json['defaultQuantity'] ?? 0,
      defaultDiscount: (json['defaultDiscount'] ?? 0.0).toDouble(),
      suppliers: (json['suppliers'] as List<dynamic>?)?.map((s) => ProductSuppliersModel.fromJson(s)).toList() ?? [],
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

  factory ProductModel.empty() {
    return ProductModel(
      id: '',
      name: '',
      category: const CategoryModel(id: '', name: ''),
      defaultPrice: 0.0,
      defaultQuantity: 0,
      defaultDiscount: 0.0,
      suppliers: const [],
      alcoholContent: 0.0,
      description: '',
      deleted: false,
      tags: const [],
      stockStatus: 'Out of Stock',
      isFeatured: false,
      isOnSale: false,
      variants: const [],
      shippingCost: 0.0,
      relatedProducts: const [],
      reviews: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      version: 0,
      isNewArrival: false,
      brand: 'Generic Brand',
      weight: 0.0,
      images: const [],
      dimensions: const DimensionsModel(),
    );
  }

  /// The [flashSaleSpecialPrice] parameter is used to set the flash sale price.
  factory ProductModel.fromFlashSaleJson(Map<String, dynamic> json, double? flashSaleSpecialPrice) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? 'Generic Brand',
      description: json['description'] ?? 'No description',
      // If the category is provided as a Map, use it; otherwise, create a default category.
      category: json['category'] is Map<String, dynamic> ? CategoryModel.fromJson(json['category']) : CategoryModel(id: json['category'] ?? '', name: 'Unknown Category'),
      defaultPrice: (json['defaultPrice'] ?? 0.0).toDouble(),
      // Assuming flash sale data might not include these fields.
      defaultQuantity: json['defaultQuantity'] ?? 0,
      defaultDiscount: (json['defaultDiscount'] ?? 0.0).toDouble(),
      suppliers: [],
      alcoholContent: (json['alcoholContent'] ?? 0.0).toDouble(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      image: json['image'],
      dimensions: json['dimensions'] is Map<String, dynamic> ? DimensionsModel.fromJson(json['dimensions']) : const DimensionsModel(),
      // If a flash sale special price is provided, create a minimal current flash sale.
      currentFlashSale: flashSaleSpecialPrice != null
          ? CurrentFlashSaleModel(
              flashSaleId: null,
              specialPrice: flashSaleSpecialPrice,
              startDate: DateTime.now(),
              endDate: DateTime.now(),
            )
          : null,
      reviews: [],
      relatedProducts: [],
      isNewArrival: json['isNewArrival'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      isOnSale: json['isOnSale'] ?? false,
      stockStatus: json['stockStatus'] ?? 'Out of Stock',
      shippingCost: (json['shippingCost'] ?? 0.0).toDouble(),
      weight: (json['weight'] ?? 0.0).toDouble(),
      deleted: json['deleted'] ?? false,
      variants: [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      version: json['version'] ?? 0,
    );
  }

  factory ProductModel.fromCart(Map<String, dynamic> json) {
    try {
      final ProductModel product = ProductModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? 'Unnamed Product',
        brand: 'Generic Brand',
        description: 'No description',
        category: const CategoryModel(id: '', name: 'Unknown Category'),
        defaultPrice: (json['defaultPrice'] ?? 0.0).toDouble(),
        defaultQuantity: json['defaultQuantity'] ?? 0,
        defaultDiscount: 0.0,
        suppliers: const [],
        alcoholContent: 0.0,
        tags: const [],
        images: json['image'] != null ? [json['image']] : const [],
        image: json['image'],
        dimensions: const DimensionsModel(),
        currentFlashSale: null,
        reviews: const [],
        relatedProducts: const [],
        isNewArrival: false,
        isFeatured: false,
        isOnSale: json['discountedPrice'] != null,
        stockStatus: 'In Stock',
        shippingCost: 0.0,
        weight: 0.0,
        deleted: false,
        variants: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 0,
      );
      return product;
    } catch (e, stack) {
      logger.e('Error loading product: $e', stackTrace: stack);
      rethrow;
    }
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
      'suppliers': suppliers.map((s) => (s as ProductSuppliersModel).toJson()).toList(),
      'alcoholContent': alcoholContent,
      'tags': tags,
      'images': images,
      'image': image,
      'dimensions': (dimensions as DimensionsModel).toJson(),
      'currentFlashSale': currentFlashSale != null ? (currentFlashSale as CurrentFlashSaleModel).toJson() : null,
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

  factory ProductModel.fromProduct(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      category: product.category is CategoryModel ? product.category as CategoryModel : CategoryModel(id: product.category.id, name: product.category.name),
      defaultPrice: product.defaultPrice,
      defaultQuantity: product.defaultQuantity,
      defaultDiscount: product.defaultDiscount,
      suppliers: product.suppliers
          .map((s) => s is ProductSuppliersModel
              ? s
              : ProductSuppliersModel(
                  id: s.id,
                  supplier: ProductSupplierModel(
                    id: s.supplier.id,
                    name: s.supplier.name,
                    contact: s.supplier.contact,
                    location: s.supplier.location,
                    createdAt: s.supplier.createdAt,
                    updatedAt: s.supplier.updatedAt,
                    version: s.supplier.version,
                  ),
                  price: s.price,
                  quantity: s.quantity,
                  discount: s.discount,
                  createdAt: s.createdAt,
                  updatedAt: s.updatedAt,
                ))
          .toList(),
      alcoholContent: product.alcoholContent,
      description: product.description,
      deleted: product.deleted,
      tags: product.tags,
      stockStatus: product.stockStatus,
      isFeatured: product.isFeatured,
      isOnSale: product.isOnSale,
      variants: product.variants.map((v) => v is VariantModel ? v : VariantModel(type: v.type, value: v.value, id: v.id)).toList(),
      shippingCost: product.shippingCost,
      relatedProducts: product.relatedProducts
          .map((rp) => rp is RelatedProductModel
              ? rp
              : RelatedProductModel(
                  productId: rp.productId,
                  matchedFields: rp.matchedFields,
                  relationshipType: rp.relationshipType,
                  priority: rp.priority,
                ))
          .toList(),
      reviews: product.reviews
          .map((r) => r is ReviewModel
              ? r
              : ReviewModel(
                  userId: r.userId,
                  rating: r.rating,
                  comment: r.comment,
                  createdAt: r.createdAt,
                  updatedAt: r.updatedAt,
                ))
          .toList(),
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      version: product.version,
      isNewArrival: product.isNewArrival,
      brand: product.brand,
      weight: product.weight,
      images: product.images,
      image: product.image,
      dimensions: product.dimensions is DimensionsModel
          ? product.dimensions as DimensionsModel
          : DimensionsModel(
              length: product.dimensions.length,
              width: product.dimensions.width,
              height: product.dimensions.height,
            ),
      currentFlashSale: product.currentFlashSale is CurrentFlashSaleModel
          ? product.currentFlashSale as CurrentFlashSaleModel
          : (product.currentFlashSale != null
              ? CurrentFlashSaleModel(
                  flashSaleId: product.currentFlashSale!.flashSaleId,
                  specialPrice: product.currentFlashSale!.specialPrice,
                  startDate: product.currentFlashSale!.startDate,
                  endDate: product.currentFlashSale!.endDate,
                )
              : null),
    );
  }
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

class ProductSupplierModel extends ProductSupplier {
  const ProductSupplierModel({
    required super.id,
    required super.name,
    required super.contact,
    required super.location,
    required super.createdAt,
    required super.updatedAt,
    super.version,
  });

  factory ProductSupplierModel.fromJson(Map<String, dynamic> json) {
    return ProductSupplierModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      contact: json['contact'] ?? '',
      location: json['location'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'contact': contact,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }

  factory ProductSupplierModel.empty() {
    return ProductSupplierModel(
      id: '',
      name: '',
      contact: '',
      location: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

class ProductSuppliersModel extends ProductSuppliers {
  const ProductSuppliersModel({
    required super.id,
    required ProductSupplierModel super.supplier,
    super.price,
    super.quantity,
    super.discount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductSuppliersModel.fromJson(Map<String, dynamic> json) {
    return ProductSuppliersModel(
      id: json['_id'] ?? '',
      supplier: json['supplier'] is Map<String, dynamic> ? ProductSupplierModel.fromJson(json['supplier']) : ProductSupplierModel.empty(),
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      discount: (json['discount'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'supplier': (supplier as ProductSupplierModel).toJson(),
      'price': price,
      'quantity': quantity,
      'discount': discount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProductSuppliersModel.empty() {
    return ProductSuppliersModel(
      id: '',
      supplier: ProductSupplierModel.empty(),
      price: 0.0,
      quantity: 0,
      discount: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

class DimensionsModel extends Dimensions {
  const DimensionsModel({
    super.length = 0.0,
    super.width = 0.0,
    super.height = 0.0,
  });

  factory DimensionsModel.fromJson(Map<String, dynamic> json) {
    return DimensionsModel(
      length: (json['length'] ?? 0.0).toDouble(),
      width: (json['width'] ?? 0.0).toDouble(),
      height: (json['height'] ?? 0.0).toDouble(),
    );
  }

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
    super.flashSaleId,
    required super.specialPrice,
    required super.startDate,
    required super.endDate,
  });

  factory CurrentFlashSaleModel.fromJson(Map<String, dynamic> json) {
    return CurrentFlashSaleModel(
      flashSaleId: json['flashSale'],
      specialPrice: (json['specialPrice'] ?? 0.0).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

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
    super.userId,
    required super.rating,
    super.comment,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userId: json['user'],
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

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
    required super.productId,
    super.matchedFields,
    super.relationshipType,
    super.priority,
  });

  factory RelatedProductModel.fromJson(Map<String, dynamic> json) {
    return RelatedProductModel(
      productId: json['product'] ?? '',
      matchedFields: List<String>.from(json['matchedFields'] ?? []),
      relationshipType: json['relationshipType'] ?? 'related',
      priority: json['priority'] ?? 1,
    );
  }

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
    required super.type,
    required super.value,
    super.id,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      type: json['type'] ?? '',
      value: json['value'] ?? '',
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      '_id': id,
    };
  }
}

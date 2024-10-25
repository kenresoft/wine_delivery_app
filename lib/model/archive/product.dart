import 'package:equatable/equatable.dart';
import 'package:wine_delivery_app/model/archive/review.dart';

import 'category.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final Category category;
  final String image;
  final double price;
  final double alcoholContent;
  final String description;
  final List<Review> reviews;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    required this.alcoholContent,
    required this.description,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      category: Category.fromJson(json['category']),
      image: json['image'],
      price: json['price'].toDouble(),
      alcoholContent: json['alcoholContent'].toDouble(),
      description: json['description'],
      reviews: (json['reviews'] as List).map((review) => Review.fromJson(review)).toList(),
    );
  }

  factory Product.empty() {
    return const Product(
      id: '',
      name: '',
      category: Category(id: '', name: ''),
      image: '',
      price: -1.0,
      alcoholContent: -1.0,
      description: '',
      reviews: [],
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      category,
      image,
      price,
      alcoholContent,
      description,
      reviews,
    ];
  }

  @override
  bool get stringify => true;
}


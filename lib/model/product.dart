class Product {
  final String id;
  final String name;
  final Category category;
  final String image;
  final double price;
  final double alcoholContent;
  final String description;
  final List<Review> reviews;

  Product({
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
    return Product(
      id: '',
      name: '',
      category: Category(id: '', name: ''),
      image: '',
      price: -1,
      alcoholContent: -1,
      description: '',
      reviews: const [],
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Review {
  final String userId;
  final int rating;
  final String review;

  Review({
    required this.userId,
    required this.rating,
    required this.review,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userId: json['userId'],
      rating: json['rating'],
      review: json['review'],
    );
  }
}

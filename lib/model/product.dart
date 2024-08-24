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
      price: -1.0,
      alcoholContent: -1.0,
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
  final dynamic user;
  final double rating;
  final String review;

  Review({
    required this.user,
    required this.rating,
    required this.review,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      user: json['user'] is String ? json['user'] : User.fromJson(json['user']),
      // user: User.fromJson(json['user']),
      rating: json['rating'].toDouble(),
      review: json['review'],
    );
  }
}

class User {
  final String id;
  final String email;
  final String username;
  // final List<Favorite> favorites; // List of Favorite objects

  User({
    required this.id,
    required this.email,
    required this.username,
    // required this.favorites,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      username: json['username'],
      //favorites: (json['favorites'] as List<dynamic>).map((favoriteJson) => Favorite.fromJson(favoriteJson)).toList(),
    );
  }
}

class Profile {
  final String id;
  final String email;
  final String username;
  final List<Favorite> favorites;

  Profile({
    required this.id,
    required this.email,
    required this.username,
    required this.favorites,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['_id'],
      email: json['email'],
      username: json['username'],
      favorites: (json['favorites'] as List<dynamic>).map((favoriteJson) {
        return Favorite.fromJson(favoriteJson);
      }).toList(),
    );
  }
}

class Favorite {
  final String id;
  final dynamic product;

  Favorite({
    required this.id,
    required this.product,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['_id'],
      product: json['product'] is String ? json['product'] : json['product']['_id'],
    );
  }
}

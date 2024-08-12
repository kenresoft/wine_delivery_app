import 'enums/wine_category.dart';

class Wine {
  final String name;
  final WineCategory category;
  final double price;
  final double rating;
  final double alcoholContent;
  final String image;
  final String description;
  final int popularity;

  factory Wine.error() {
    return const Wine(
      name: 'error',
      category: WineCategory.red,
      price: -1,
      rating: -1,
      alcoholContent: -1,
      image: 'error',
      description: 'error',
      popularity: -1,
    );
  }

  const Wine({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.alcoholContent,
    required this.image,
    required this.description,
    required this.popularity,
  });

  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(
      name: json['name'],
      category: WineCategory.values.firstWhere((e) => e.toString() == 'WineCategory.${json['category']}'),
      image: json['image'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      alcoholContent: json['alcoholContent'].toDouble(),
      description: json['description'],
      popularity: json['popularity'],
    );
  }
}
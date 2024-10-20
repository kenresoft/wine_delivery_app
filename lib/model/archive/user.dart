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
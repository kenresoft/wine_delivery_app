class User {
  final String id;
  final String username;
  final String email;
  final bool isAdmin;
  final List<String> favorites;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.isAdmin = false,
    this.favorites = const [],
  });
}
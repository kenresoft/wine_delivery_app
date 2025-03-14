import 'package:vintiora/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.username,
    required super.email,
    super.isAdmin,
    super.favorites,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<String> favoritesList = [];

    if (json['favorites'] != null) {
      if (json['favorites'] is List) {
        favoritesList = (json['favorites'] as List).map((item) => item is String ? item : item['_id'].toString()).cast<String>().toList();
      }
    }

    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      favorites: favoritesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isAdmin': isAdmin,
      'favorites': favorites,
    };
  }
}

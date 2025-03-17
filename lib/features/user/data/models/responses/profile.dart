import 'package:equatable/equatable.dart';

import '../../../../favorite/data/models/responses/favorite.dart';

class Profile extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? profileImage;
  final List<Favorite> favorites;

  const Profile({
    required this.id,
    required this.email,
    required this.username,
    required this.profileImage,
    required this.favorites,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['_id'],
      email: json['email'],
      username: json['username'],
      profileImage: json['profileImage'],
      favorites: (json['favorites'] as List<dynamic>).map((favoriteJson) {
        return Favorite.fromJson(favoriteJson);
      }).toList(),
    );
  }

  factory Profile.empty() {
    return Profile(
      id: 'N/A',
      email: 'no-email@vintioraapp.com',
      username: 'Anonymous',
      profileImage: null,
      favorites: [],
    );
  }

  @override
  List<Object?> get props => [id, email, username, profileImage, favorites];

  @override
  bool get stringify => true;
}
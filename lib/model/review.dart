import 'package:equatable/equatable.dart';

import 'user.dart';

class Review extends Equatable {
  final dynamic user;
  final double rating;
  final String review;

  const Review({
    required this.user,
    required this.rating,
    required this.review,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      user: json['user'] is String ? json['user'] : User.fromJson(json['user']),
      rating: json['rating'].toDouble(),
      review: json['review'],
    );
  }

  @override
  List<Object?> get props => [user, rating, review];

  @override
  bool get stringify => true;
}
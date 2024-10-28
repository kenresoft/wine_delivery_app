import 'dart:convert';

import '../utils/helpers.dart';
import 'user.dart';

Reviews reviewsFromJson(String str) => Reviews.fromJson(json.decode(str));

String reviewsToJson(Reviews data) => json.encode(data.toJson());

class Reviews {
  Reviews({
    this.user,
    this.rating,
    this.comment,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  Reviews.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    rating = toDouble(json['rating']);
    comment = json['comment'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  User? user;
  double? rating;
  String? comment;
  String? id;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['rating'] = rating;
    map['comment'] = comment;
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

  @override
  String toString() {
    return 'Reviews{'
        'user: $user, '
        'rating: $rating, '
        'comment: $comment, '
        'id: $id, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        '}';
  }
}

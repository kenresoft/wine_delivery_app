import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.username,
    this.email,
    this.favorites,
    this.v,
    this.profileImage,
    this.otpCode,
    this.otpExpiresAt,
  });

  User.fromJson(dynamic json) {
    id = json['_id'];
    username = json['username'];
    email = json['email'];
    favorites = json['favorites'] != null ? json['favorites'].cast<String>() : [];
    v = json['__v'];
    profileImage = json['profileImage'];
    otpCode = json['otpCode'];
    otpExpiresAt = json['otpExpiresAt'];
  }

  String? id;
  String? username;
  String? email;
  List<String>? favorites;
  int? v;
  String? profileImage;
  String? otpCode;
  String? otpExpiresAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['favorites'] = favorites;
    map['__v'] = v;
    map['profileImage'] = profileImage;
    map['otpCode'] = otpCode;
    map['otpExpiresAt'] = otpExpiresAt;
    return map;
  }
}

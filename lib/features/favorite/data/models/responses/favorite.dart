import 'package:equatable/equatable.dart';

class Favorite extends Equatable {
  final String id;
  final dynamic product;

  const Favorite({
    required this.id,
    required this.product,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['_id'],
      product: json['product'] is String ? json['product'] : json['product']['_id'],
    );
  }

  @override
  List<Object?> get props => [id, product];

  @override
  bool get stringify => true;
}
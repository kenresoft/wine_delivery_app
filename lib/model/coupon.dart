import 'package:equatable/equatable.dart';

class Coupon extends Equatable {
  final String code;
  final double discount;
  final double minimumPurchaseAmount;
  final DateTime expiryDate;

  const Coupon({
    required this.code,
    required this.discount,
    required this.minimumPurchaseAmount,
    required this.expiryDate,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      code: json['code'],
      discount: double.parse(json['discount'].toString()),
      minimumPurchaseAmount: double.parse(json['minimumPurchaseAmount'].toString()),
      expiryDate: DateTime.parse(json['expiryDate'].toString()),
    );
  }

  @override
  List<Object?> get props => [code, discount, minimumPurchaseAmount, expiryDate];

  @override
  bool get stringify => true;
}
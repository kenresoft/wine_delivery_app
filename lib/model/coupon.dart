class Coupon {
  final String code;
  final double discount;
  final double minimumPurchaseAmount;
  final DateTime expiryDate;

  Coupon({
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
}
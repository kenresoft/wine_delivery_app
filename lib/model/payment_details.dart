import 'package:equatable/equatable.dart';

class PaymentDetails extends Equatable {
  final String? paymentIntent;

  const PaymentDetails({required this.paymentIntent});

  factory PaymentDetails.fromJson(Map<String, dynamic>? json) {
    return PaymentDetails(
      paymentIntent: json?['paymentIntent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentIntent': paymentIntent,
    };
  }

  @override
  List<Object?> get props => [paymentIntent];

  @override
  bool? get stringify => true;
}
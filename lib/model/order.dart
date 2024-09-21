import 'package:equatable/equatable.dart';
import 'package:wine_delivery_app/utils/enums.dart';

import '../utils/extensions.dart';
import 'order_item.dart';
import 'payment_details.dart';

class Order extends Equatable {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final String shipmentId;
  final num subTotal;
  final num totalCost;
  final OrderStatus status;
  final String createdAt;
  final PaymentDetails? paymentDetails;
  final String? note;
  final String? trackingNumber;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.shipmentId,
    required this.subTotal,
    required this.totalCost,
    required this.status,
    required this.createdAt,
    this.paymentDetails,
    this.note,
    this.trackingNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      userId: json['user'],
      items: (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList(),
      shipmentId: json['shipment'],
      subTotal: json['subTotal'],
      totalCost: json['totalCost'],
      status: OrderStatusExtension.fromString(json['status']),
      createdAt: json['createdAt'],
      paymentDetails: PaymentDetails.fromJson(json['paymentDetails']),
      note: json['note'],
      trackingNumber: json['trackingNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'shipment': shipmentId,
      'subTotal': subTotal,
      'totalCost': totalCost,
      'status': status.toShortString(),
      'createdAt': createdAt,
      'paymentDetails': paymentDetails?.toJson(),
      'note': note,
      'trackingNumber': trackingNumber,
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      items,
      shipmentId,
      subTotal,
      totalCost,
      status,
      createdAt,
      paymentDetails,
      note,
      trackingNumber,
    ];
  }

  @override
  bool? get stringify => true;
}



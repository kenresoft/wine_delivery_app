import 'package:equatable/equatable.dart';
import 'package:wine_delivery_app/utils/enums.dart';

import '../utils/extensions.dart';
import '../utils/globals.dart';
import 'order_item.dart';
import 'payment_details.dart';

class Order extends Equatable {
  final String? id;
  final String? userId;
  final List<OrderItem>? items;
  final String? shipmentId;
  final double? subTotal;
  final double? totalCost;
  final OrderStatus? status;
  final String? createdAt;
  final PaymentDetails? paymentDetails;
  final String? note;
  final String? trackingNumber;

  const Order({
    this.id,
    this.userId,
    this.items,
    this.shipmentId,
    this.subTotal,
    this.totalCost,
    this.status,
    this.createdAt,
    this.paymentDetails,
    this.note,
    this.trackingNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      userId: json['user'],
      items: json['items'] != null ? (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList() : null,
      shipmentId: json['shipment'],
      subTotal: toDouble(json['subTotal']),
      totalCost: toDouble(json['totalCost']),
      status: json['status'] != null ? OrderStatusExtension.fromString(json['status']) : null,
      createdAt: json['createdAt'],
      paymentDetails: json['paymentDetails'] != null ? PaymentDetails.fromJson(json['paymentDetails']) : null,
      note: json['note'],
      trackingNumber: json['trackingNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'items': items?.map((item) => item.toJson()).toList(),
      'shipment': shipmentId,
      'subTotal': subTotal,
      'totalCost': totalCost,
      'status': status?.toShortString(),
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



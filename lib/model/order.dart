/*
import 'package:equatable/equatable.dart';

part 'order_item.dart';

part 'order_status.dart';

class Order extends Equatable {
  final String orderId;
  final DateTime orderDate;
  final List<OrderItem> items;
  final OrderStatus status;

  const Order({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.status,
  });

  factory Order.empty() {
    return Order(
      orderId: '', // Or generate a unique ID here
      orderDate: DateTime.now(),
      items: const [],
      status: OrderStatus.pending,
    );
  }

  Order copyWith({
    String? orderId,
    DateTime? orderDate,
    List<OrderItem>? items,
    OrderStatus? status,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      orderDate: orderDate ?? this.orderDate,
      items: items ?? this.items,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [orderId, orderDate, items, status];

  @override
  bool get stringify => true; // Set stringify to true for better debugging
}
*/

import 'package:equatable/equatable.dart';
import 'package:wine_delivery_app/model/product.dart';

part 'order_item.dart';

class Order extends Equatable {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final String shipmentId;
  final int subTotal;
  final int totalCost;
  final String status;
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
      status: json['status'],
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
      'status': status,
      'createdAt': createdAt,
      'paymentDetails': paymentDetails?.toJson(),
      'note': note,
      'trackingNumber': trackingNumber,
    };
  }

  @override
  List<Object?> get props => [
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

  @override
  bool? get stringify => true;
}



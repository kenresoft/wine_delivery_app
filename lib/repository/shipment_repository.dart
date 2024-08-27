import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/model/shipment.dart';

import '../utils/constants.dart';
import 'auth_repository.dart';

class ShipmentRepository {
  ShipmentRepository();

  ShipmentRepository._();

  static final ShipmentRepository _instance = ShipmentRepository._();

  static ShipmentRepository getInstance() {
    return _instance;
  }

  static const String _baseUrl = '${Constants.baseUrl}/api/shipment';

  Future<List<Shipment>> getShipmentDetails() async {
    final token = await authRepository.getToken();

    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final shipment = data['shipment'] as List<dynamic>;

        return shipment.map((shipmentJson) => Shipment.fromJson(shipmentJson)).toList();
      }
      if (response.statusCode == 401) {
        throw 'Unauthorized: Please log in again.';
      }
      throw 'Error fetching shipment details: ${response.statusCode} - ${response.reasonPhrase}';
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (e is SocketException) {
        throw 'Failed to retrieve shipment details. \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team.';
      }
      rethrow;
    }
  }

  Future<Shipment> saveShipmentDetails({
    required String country,
    required String state,
    required String city,
    required String company,
    required String address,
    required String apartment,
    required String fullName,
    required String zipCode,
    required String note,
  }) async {
    final token = await authRepository.getToken();

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'country': country,
          'state': state,
          'city': city,
          'company': company,
          'address': address,
          'apartment': apartment,
          'name': fullName,
          'zip': zipCode,
          'note': note,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final shipmentJson = data['shipment'];

        if (shipmentJson != null) {
          return Shipment.fromJson(shipmentJson);
        }
        throw 'Error parsing created shipment data from the server.';
      }
      if (response.statusCode == 401) {
        throw 'Unauthorized: Please log in again.';
      }
      throw 'Error creating shipment details: ${response.statusCode} - ${response.reasonPhrase}';
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (e is SocketException) {
        throw 'Failed to create shipment details. \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team.';
      }
      rethrow;
    }
  }

  Future<Shipment> getShipmentDetailsById(String shipmentId) async {
    final token = await authRepository.getToken();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$shipmentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final shipmentJson = data['shipment'];

        if (shipmentJson != null) {
          return Shipment.fromJson(shipmentJson);
        }
        throw 'Error parsing shipment details from the server.';
      }
      if (response.statusCode == 401) {
        throw 'Unauthorized: Please log in again.';
      }
      throw 'Error fetching shipment details: ${response.statusCode} - ${response.reasonPhrase}';
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (e is SocketException) {
        throw 'Failed to retrieve shipment details. \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team.';
      }
      rethrow;
    }
  }
}

final ShipmentRepository shipmentRepository = ShipmentRepository.getInstance();
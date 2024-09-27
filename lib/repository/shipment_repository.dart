import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wine_delivery_app/model/shipment.dart';
import 'package:wine_delivery_app/repository/decision_repository.dart';

import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/utils.dart';

class ShipmentRepository {
  ShipmentRepository();

  ShipmentRepository._();

  static final ShipmentRepository _instance = ShipmentRepository._();

  static ShipmentRepository getInstance() {
    return _instance;
  }

  static final String _baseUrl = '${Constants.baseUrl}/api/shipment';

  Future<Shipment?> getShipmentDetails() async {
    return decisionRepository.decide(
      cacheKey: 'getShipmentDetails',
      endpoint: _baseUrl,
      onSuccess: (data) async {
        final shipment = data['shipment'];

        return Shipment.fromJson(shipment);
      },
      onError: (error) async {
        return null;
      },
    );

    /*try {
      final response = await Utils.makeRequest(_baseUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final shipment = data['shipment'];

        return Shipment.fromJson(shipment);
      }
      if (response.statusCode == 401) {
        throw 'Unauthorized: Please log in again.';
      }
      throw 'Error fetching shipment details: ${response.statusCode} - ${response.reasonPhrase}';
    } catch (e) {
      if (kDebugMode) {
        logger.e(e.toString());
      }
      if (e is SocketException) {
        throw 'Failed to retrieve shipment details. \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team.';
      }
      rethrow;
    }*/
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

    try {
      final response = await Utils.makeRequest(
        _baseUrl,
        method: RequestMethod.post,
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
        logger.e(e.toString());
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

    try {
      final response = await Utils.makeRequest('$_baseUrl/$shipmentId');

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
        logger.e(e.toString());
      }
      if (e is SocketException) {
        throw 'Failed to retrieve shipment details. \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team.';
      }
      rethrow;
    }
  }

  Future<Map<String, List<String>>> loadCountriesWithStates() async {
    // Load JSON data from assets
    String jsonString = await rootBundle.loadString('assets/countries.json');
    List<dynamic> countriesData = json.decode(jsonString);

    // Initialize map to store countries with their states/provinces
    Map<String, List<String>> countriesWithStates = {};

    // Iterate through each country object
    for (var country in countriesData) {
      String countryName = country['name'];
      List<dynamic> statesData = country['states'];

      // Initialize list to store states/provinces
      List<String> statesList = [];

      // Iterate through states/provinces of the country
      for (var state in statesData) {
        statesList.add(state['name']);
      }

      // Add country with its states/provinces to the map
      countriesWithStates[countryName] = statesList;
    }

    return countriesWithStates;
  }
}

final ShipmentRepository shipmentRepository = ShipmentRepository.getInstance();
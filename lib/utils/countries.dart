import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

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

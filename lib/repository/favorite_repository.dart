/*
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class FavoritesRepository {

  FavoritesRepository();

  Future<bool> isFavorite({String userId = '66c411859a596bddf001b200', required String productId}) async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/users/favorites/$productId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final favorites = data['users'][0]['favorites'] as List<dynamic>;
      return favorites.any((favorite) => favorite['product']['_id'] == productId);
    } else {
      throw Exception('Failed to load favorite status');
    }
  }

  Future<void> addFavorite({String userId = '66c411859a596bddf001b200', required String productId}) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/users/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'productId': productId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to favorites');
    }
  }

  Future<void> removeFavorite({String userId = '66c411859a596bddf001b200', required String productId}) async {
    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/api/users/favorites/$productId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites');
    }
  }
}
*/

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'auth_repository.dart';

class FavoritesRepository {
  FavoritesRepository._();

  static final FavoritesRepository _instance = FavoritesRepository._();

  // Getter for the singleton instance
  static FavoritesRepository getInstance() {
    return _instance;
  }

  FavoritesRepository();

  Future<bool> isFavorite(String productId) async {
    try {
      final token = await authRepository.getToken();
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/users/favorites/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      final favorites = data /*['users'][0]*/ ['favorites'] as List<dynamic>;
      return favorites.any((favorite) => favorite['product']['_id'] == productId);
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> addFavorite(String productId) async {
    final token = await authRepository.getToken();
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/favorites/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'productId': productId}),
    );

    print(response.statusCode);
  }

  Future<void> removeFavorite(String productId) async {
    final token = await authRepository.getToken();
    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/api/favorites/remove'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'productId': productId}),
    );
  }
}

final FavoritesRepository favoritesRepository = FavoritesRepository.getInstance();

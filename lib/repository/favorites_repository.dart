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
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/model/product.dart';
import 'package:wine_delivery_app/repository/product_repository.dart';

import '../utils/constants.dart';
import 'auth_repository.dart';

class FavoritesRepository {
  FavoritesRepository();

  FavoritesRepository._();

  static final FavoritesRepository _instance = FavoritesRepository._();

  static FavoritesRepository getInstance() {
    return _instance;
  }

  static const String _url = '${Constants.baseUrl}/api/favorites/';

  Future<List<Product>> getFavorites() async {
    final token = await authRepository.getToken();

    try {
      final response = await http.get(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic>? favoritesJson = data['favorite'];

        if (favoritesJson != null) {
          final products = <Product>[];
          for (final favoriteJson in favoritesJson) {
            final favorite = Favorite.fromJson(favoriteJson);
            final product = await productManager.getProductById(favorite.product);
            products.add(product);
          }
          return products;
        }
        throw 'Error parsing favorites from the server.';
      }
      if (response.statusCode == 401) {
        throw 'Unauthorized: Please log in again.';
      }

      throw 'Error fetching user favorites: ${response.statusCode} - ${response.reasonPhrase}';
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (e is SocketException) {
        throw 'Failed to retrieve user favorites (error code: ${/*response.statusCode ??*/ 404}). \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team at [email protected].';
      }
      rethrow;
    }
  }

  Future<bool> isLiked(String productId) async {
    try {
      final token = await authRepository.getToken();
      final response = await http.get(
        Uri.parse(_url + productId),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      final favorites = data /*['users'][0]*/ ['favorite'] as List<dynamic>;
      return favorites.any((favorite) => favorite['product']['_id'] == productId);
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> addFavorite(String productId) async {
    final token = await authRepository.getToken();
    await http.post(
      Uri.parse('${_url}add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'productId': productId}),
    );
  }

  Future<void> removeFavorite(String productId) async {
    final token = await authRepository.getToken();
    await http.delete(
      Uri.parse('${_url}remove'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'productId': productId}),
    );
  }
}

final FavoritesRepository favoritesRepository = FavoritesRepository.getInstance();

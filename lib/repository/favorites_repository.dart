import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/repository/cart_repository.dart';

import '../model/favorite.dart';
import '../model/product.dart';
import '../utils/helpers.dart';
import 'auth_repository.dart';
import 'decision_repository.dart';
// import 'package:wine_delivery_app/model/product.dart';
import 'product_repository.dart';

class FavoritesRepository {
  FavoritesRepository();

  FavoritesRepository._();

  static final FavoritesRepository _instance = FavoritesRepository._();

  static FavoritesRepository getInstance() {
    return _instance;
  }

  static final String _url = '${Constants.baseUrl}/api/favorites';

  Future<List<({Product product, int cartQuantity})>> getFavorites() async {
    return DecisionRepository().decide<List<({Product product, int cartQuantity})>>(
      cacheKey: 'getFavorites',
      endpoint: _url,
      onSuccess: (data) async {
        final List<dynamic>? favoritesJson = data['favorite'];

        if (favoritesJson != null) {
          final products = <({Product product, int cartQuantity})>[];
          for (final favoriteJson in favoritesJson) {
            final favorite = Favorite.fromJson(favoriteJson);
            final product = await productRepository.getProductById(favorite.product);
            final cartItemQuantity = await cartRepository.getItemQuantity(favorite.product);
            // logger.t(data);
            products.add((product: product, cartQuantity: cartItemQuantity));
          }
          logger.i(products.length);
          return products;
        }
        throw 'Error parsing favorites from the server.';
      },
      onError: (error) async {
        logger.e('ERROR: ${error.toString()}');
        return [(product: Product(), cartQuantity: 0)];
      },
    );
/*    try {
      final response = await Utils.makeRequest(_url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic>? favoritesJson = data['favorite'];

        if (favoritesJson != null) {
          final products = <Product>[];
          for (final favoriteJson in favoritesJson) {
            final favorite = Favorite.fromJson(favoriteJson);
            final product = await productRepository.getProductById(favorite.product);
            logger.t(response.body);
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
      // return [Product.empty()];
    } catch (e) {
      logger.e(e.toString());

      if (e is SocketException) {
        throw 'Failed to retrieve user favorites (error code: ${*/ /*response.statusCode ??*/ /* 404}). \n'
            'Please check your internet connection and try again. \n'
            'If the issue persists, contact our support team at [email protected].';
      }
      rethrow;
    }*/
  }

  Future<bool> isLiked(String productId) async {
    try {
      // final token = await authRepository.getAccessToken();
      final response = await Utils.makeRequest('$_url/$productId');

      final data = jsonDecode(response.body);
      final favorites = data /*['users'][0]*/ ['favorite'] as List<dynamic>?;
      if (favorites != null) {
        return favorites.any((favorite) => favorite['product']['_id'] == productId);
      } else if (favorites == null) {
        'Not currently logged in!'.toasts;
      }
      return false;
    } on Exception {
      return false;
    }
  }

  Future<void> addFavorite(String productId) async {
    final token = await authRepository.getAccessToken();
    await http.post(
      Uri.parse('$_url/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'productId': productId}),
    );
  }

  Future<void> removeFavorite(String productId) async {
    final token = await authRepository.getAccessToken();
    await http.delete(
      Uri.parse('$_url/remove'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'productId': productId}),
    );
  }
}

final FavoritesRepository favoritesRepository = FavoritesRepository.getInstance();

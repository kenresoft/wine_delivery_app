import 'package:extensionresoft/extensionresoft.dart';
import 'package:get_it/get_it.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/cart/data/repositories/cart_repository.dart';
import 'package:vintiora/features/product/data/models/responses/product.dart';

// import 'package:vintiora/model/product.dart';
import '../../../product/data/repositories/product_repository.dart';
import '../models/responses/favorite.dart';

class FavoritesRepository {
  FavoritesRepository();

  // FavoritesRepository._();

  // static final FavoritesRepository _instance = FavoritesRepository._();

  /*static FavoritesRepository getInstance() {
    return _instance;
  }*/

  static final String _url = '${Constants.baseUrl}/api/favorites';

  Future<List<({Product product, int cartQuantity})>> getFavorites() async {
    final apiService = GetIt.I<IApiService>();
    final result = await apiService.request(
      endpoint: _url,
      parser: (data) => data as List<dynamic>,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) async {
        try {
          final products = await Future.wait(
            data.map((favoriteJson) async {
              try {
                final favorite = Favorite.fromJson(favoriteJson['favorite']);
                final product = await productRepository.getProductById(favorite.product);
                final cartItemQuantity = await cartRepository.getItemQuantity(favorite.product);
                return (product: product, cartQuantity: cartItemQuantity);
              } catch (e) {
                logger.e('Error fetching data for product: $e');
                return (product: Product(), cartQuantity: 0);
              }
            }).toList(),
          );
          return products;
        } catch (e) {
          throw Exception('Error parsing favorite products from the server.');
        }
      },
    );
  }

  Future<bool> isLiked(String productId) async {
    final apiService = GetIt.I<IApiService>();
    final result = await apiService.request(
      endpoint: '$_url/$productId',
      parser: (data) => data as Map<String, dynamic>,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) {
        try {
          final favorites = data /*['users'][0]*/ ['favorite'] as List<dynamic>?;
          if (favorites != null) {
            return favorites.any((favorite) => favorite['product']['_id'] == productId);
          } else {
            Nav.showToast('Not currently logged in!');
          }
          return false;
        } catch (e) {
          throw Exception('Error parsing favorite data from the server.');
        }
      },
    );
  }

  Future<void> addFavorite(String productId) async {
    final apiService = GetIt.I<IApiService>();

    final result = await apiService.request(
      endpoint: '$_url/add',
      method: RequestMethod.post,
      data: {'productId': productId},
      parser: (data) => data as Map<String, dynamic>,
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => {},
    );
  }

  Future<void> removeFavorite(String productId) async {
    final apiService = GetIt.I<IApiService>();

    final result = await apiService.request(
      endpoint: '$_url/remove',
      method: RequestMethod.delete,
      data: {'productId': productId},
      parser: (data) => data as Map<String, dynamic>,
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => {},
    );
  }
}

// final FavoritesRepository favoritesRepository = FavoritesRepository.getInstance();

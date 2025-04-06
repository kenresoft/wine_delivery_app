import 'package:extensionresoft/extensionresoft.dart';
import 'package:get_it/get_it.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/cart/data/repositories/cart_repository.dart';
import 'package:vintiora/features/favorite/data/models/responses/favorite.dart';
import 'package:vintiora/features/product/domain/entities/product.dart';
import 'package:vintiora/features/product/domain/repositories/product_repository.dart';

class FavoritesRepository {
  FavoritesRepository();

  // final CartRepository cartRepository = GetIt.I<CartRepository>();

  static final String _url = ApiConstants.favorites;

  Future<List<({Product product, int cartQuantity})>> getFavorites() async {
    final apiService = GetIt.I<IApiService>();
    final result = await apiService.request(
      endpoint: _url,
      parser: (data) => data as Map<String, dynamic>,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) async {
        try {
          final List<dynamic> favoriteJson = data['favorite'];
          final favoriteFutures = favoriteJson.map((e) async {
            final favorite = Favorite.fromJson(e);

            final productFuture = GetIt.I<ProductRepository>().getProductById(favorite.product);
            final cartItemQuantityFuture = cartRepository.getItemQuantity(favorite.product);

            final (product, cartItemQuantity) = await (
              productFuture,
              cartItemQuantityFuture,
            ).wait;

            final p = product.fold(
              (l) => Product.empty(),
              (r) => r,
            );
            return (product: p, cartQuantity: cartItemQuantity);
          });

          return await Future.wait(favoriteFutures);
        } catch (e) {
          logger.e('Error fetching favorite products: $e');
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
          final favorites = data['favorite'] as List<dynamic>?;
          if (favorites != null) {
            return favorites.any((favorite) => favorite['product']['_id'] == productId);
          } else {
            Nav.showToast('Not currently logged in!');
            return false;
          }
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

    return result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
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

    return result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }
}

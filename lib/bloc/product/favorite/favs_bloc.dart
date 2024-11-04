import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wine_delivery_app/repository/cache_repository.dart';

import '../../../model/product.dart';
import '../../../repository/favorites_repository.dart';

part 'favs_event.dart';
part 'favs_state.dart';

class FavsBloc extends Bloc<FavsEvent, FavsState> {
  FavsBloc() : super(FavsInitial()) {
    on<InitLike>((event, emit) async {
      final favs = await FavoritesRepository().getFavorites();
      final isLiked = await FavoritesRepository().isLiked(event.productId);
      emit(FavsLoaded(favs, isLiked, event.productId));
    });

    on<LoadFavs>((event, emit) async {
      try {
        final favs = await FavoritesRepository().getFavorites();
        if (favs.first.product.id != null) {
          emit(FavsLoaded(favs, false, ''));
        } else {
          emit(FavsError(error: 'No favorite item yet!'));
        }
      } catch (e) {
        emit(FavsError(error: e.toString()));
      }
    });

    on<ToggleLike>((event, emit) async {
      try {
        final isLiked = await FavoritesRepository().isLiked(event.productId);
        if (isLiked) {
          await FavoritesRepository().removeFavorite(event.productId);
          await cacheRepository.clearCache('getFavorites');
        } else {
          await FavoritesRepository().addFavorite(event.productId);
          await cacheRepository.clearCache('getFavorites');
        }

        final updatedFavs = await FavoritesRepository().getFavorites();
        emit(FavsLoaded(List.from(updatedFavs), !isLiked, event.productId));
      } catch (e) {
        emit(FavsError(error: e.toString()));
      }
    });
  }
}

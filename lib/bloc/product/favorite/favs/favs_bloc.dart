import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wine_delivery_app/model/product.dart';
import 'package:wine_delivery_app/repository/favorites_repository.dart';

part 'favs_event.dart';

part 'favs_state.dart';

class FavsBloc extends Bloc<FavsEvent, FavsState> {
  FavsBloc() : super(FavsInitial()) {
    on<LoadFavs>((event, emit) async {
      try {
        final favs = await favoritesRepository.getFavorites();
        emit(FavsLoaded(favs));
      } catch (e) {
        emit(FavsError(error: e.toString()));
      }
    });
  }
}

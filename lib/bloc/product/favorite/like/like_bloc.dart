import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../repository/favorites_repository.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc() : super(const InitialState(false, '')) {
    on<Init>(
      (event, emit) async {
        final isLiked = await favoritesRepository.isLiked(event.productId);
        emit(InitialState(isLiked, event.productId));
      },
    );
    on<Like>((event, emit) async {
      final isLiked = await favoritesRepository.isLiked(event.productId);
      if (isLiked) {
        favoritesRepository.removeFavorite(event.productId);
        emit(ToggleState(false, event.productId));
      } else {
        favoritesRepository.addFavorite(event.productId);
        emit(ToggleState(true, event.productId));
      }
    });
  }
}

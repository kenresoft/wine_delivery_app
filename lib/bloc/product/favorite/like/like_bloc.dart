import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../repository/like_repository.dart';

part 'favorite_event.dart';

part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc() : super(const LikeState(false, '')) {
    on<Like>((event, emit) async {
      final isLiked = await favoritesRepository.isLiked(event.productId);
      if (isLiked) {
        favoritesRepository.removeFavorite(event.productId);
        emit(LikeState(false, event.productId));
      } else {
        favoritesRepository.addFavorite(event.productId);
        emit(LikeState(true, event.productId));
      }
    });
  }
}

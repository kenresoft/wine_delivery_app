part of 'favs_bloc.dart';

sealed class FavsState extends Equatable {
  const FavsState();

  @override
  List<Object> get props => [];
}

class FavsInitial extends FavsState {}

class FavsLoaded extends FavsState {
  final List<({Product product, int cartQuantity})> favorites;
  final bool isLiked;
  final String productId;

  const FavsLoaded(this.favorites, this.isLiked, this.productId);

  @override
  List<Object> get props => [favorites, isLiked, productId];
}

class FavUpdated extends FavsState {
  final bool isLiked;
  final String productId;

  const FavUpdated(this.isLiked, this.productId);

  @override
  List<Object> get props => [isLiked, productId];
}

class FavsError extends FavsState {
  final String error;
  const FavsError({required this.error});

  @override
  List<Object> get props => [error];
}

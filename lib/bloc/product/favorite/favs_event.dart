part of 'favs_bloc.dart';

abstract class FavsEvent extends Equatable {
  const FavsEvent();

  @override
  List<Object> get props => [];
}

class InitLike extends FavsEvent {
  final String productId;

  const InitLike(this.productId);

  @override
  List<Object> get props => [productId];
}

class LoadFavs extends FavsEvent {}

class ToggleLike extends FavsEvent {
  final String productId;
  final bool reload;

  const ToggleLike(this.productId, this.reload);

  @override
  List<Object> get props => [productId];
}

class ToggleAndLoad extends FavsEvent {
  final String productId;

  const ToggleAndLoad(this.productId);

  @override
  List<Object> get props => [productId];
}

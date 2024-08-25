part of 'like_bloc.dart';

sealed class LikeState extends Equatable {
  const LikeState();
}

class InitialState extends LikeState {
  const InitialState(this.isLiked, this.productId);

  final bool isLiked;
  final String productId;

  @override
  List<Object> get props => [isLiked, productId];
}

class ToggleState extends LikeState {
  const ToggleState(this.isLiked, this.productId);

  final bool isLiked;
  final String productId;

  @override
  List<Object> get props => [isLiked, productId];
}
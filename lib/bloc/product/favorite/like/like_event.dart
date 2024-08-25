part of 'like_bloc.dart';

sealed class LikeEvent extends Equatable {
  const LikeEvent();
}

class Init extends LikeEvent {
  final String productId;

  const Init(this.productId);

  @override
  List<Object> get props => [productId];
}

class Like extends LikeEvent {
  final String productId;

  const Like(this.productId);

  @override
  List<Object> get props => [productId];
}

class UnLike extends LikeEvent {
  final String productId;

  const UnLike(this.productId);

  @override
  List<Object> get props => [productId];
}
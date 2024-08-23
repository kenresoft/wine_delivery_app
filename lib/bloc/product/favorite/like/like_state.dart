part of 'like_bloc.dart';

class LikeState extends Equatable {
  const LikeState(this.isLiked, this.productId);

  final bool isLiked;
  final String productId;

  @override
  List<Object> get props => [isLiked, productId];
}

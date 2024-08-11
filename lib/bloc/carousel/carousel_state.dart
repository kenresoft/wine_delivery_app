part of 'carousel_bloc.dart';

sealed class CarouselState extends Equatable {
  const CarouselState();
}

final class CarouselPosition extends CarouselState {
  final int currentItem;

  const CarouselPosition({required this.currentItem});

  @override
  List<Object> get props => [currentItem];
}

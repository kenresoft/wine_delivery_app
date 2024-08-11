part of 'carousel_bloc.dart';

sealed class CarouselEvent extends Equatable {
  const CarouselEvent();
}

/*class CarouselInit extends CarouselEvent {
  const CarouselInit();

  @override
  List<Object?> get props => [];
}*/

class CarouselTap extends CarouselEvent {
  const CarouselTap({required this.value});

  final int value;

  @override
  List<Object?> get props => [value];
}
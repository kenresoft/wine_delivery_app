part of 'carousel_bloc.dart';

sealed class CarouselState extends Equatable {
  const CarouselState();
}

final class CarouselInitial extends CarouselState {
  final CarouselController carouselController;

  const CarouselInitial(this.carouselController);

  @override
  List<Object> get props => [carouselController];
}

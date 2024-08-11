import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'carousel_event.dart';
part 'carousel_state.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  CarouselBloc() : super(const CarouselPosition(currentItem: 0)) {
    on<CarouselTap>((event, emit) {
      emit(CarouselPosition(currentItem: event.value));
    });

  }

}

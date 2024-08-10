import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'carousel_event.dart';

part 'carousel_state.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  CarouselBloc() : super(CarouselInitial(CarouselController())) {
    final controller = CarouselController();

    on<CarouselInit>((event, emit) {
      controller.addListener(
        () {
          debugPrint('started!');
        },
      );
      emit(CarouselInitial(controller));
    });

    on<CarouselTap>((event, emit) {
      controller.animateTo((event.value + 1) * 350, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      //emit(CarouselInitial(controller));
    });



  }

}

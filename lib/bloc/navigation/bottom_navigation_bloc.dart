import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_navigation_event.dart';

part 'bottom_navigation_state.dart';

// Bloc
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<PageTapped>((event, emit) {
      emit(PageChanged(selectedIndex:  event.index));
    });
  }
}

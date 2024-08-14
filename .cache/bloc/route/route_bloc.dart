// navigation_bloc.dart
import 'package:bloc/bloc.dart';

import 'route_event.dart';
import 'route_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(HomePageState()) {
    on<NavigateToHome>(
      (event, emit) => emit(
        HomePageState(),
      ),
    );
    on<NavigateToCategories>(
      (event, emit) => emit(
        CategoriesPageState(),
      ),
    );
    on<NavigateToCart>((event, emit) => emit(CartPageState()));
    on<NavigateToProfile>(
      (event, emit) => emit(
        ProfilePageState(),
      ),
    );
  }
}

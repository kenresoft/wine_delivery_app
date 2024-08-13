// navigation_state.dart
import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();
}

class HomePageState extends NavigationState {
  @override
  List<Object> get props => [];
}

class CategoriesPageState extends NavigationState {
  @override
  List<Object> get props => [];
}

class CartPageState extends NavigationState {
  @override
  List<Object> get props => [];
}

class ProfilePageState extends NavigationState {
  @override
  List<Object> get props => [];
}

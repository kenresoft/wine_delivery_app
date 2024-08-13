// navigation_event.dart
import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();
}

class NavigateToHome extends NavigationEvent {
  @override
  List<Object> get props => [];
}

class NavigateToCategories extends NavigationEvent {
  @override
  List<Object> get props => [];
}

class NavigateToCart extends NavigationEvent {
  @override
  List<Object> get props => [];
}

class NavigateToProfile extends NavigationEvent {
  @override
  List<Object> get props => [];
}


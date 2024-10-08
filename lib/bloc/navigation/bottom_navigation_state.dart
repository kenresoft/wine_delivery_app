part of 'bottom_navigation_bloc.dart';

// States
abstract class NavigationState extends Equatable {
  const NavigationState();
}


class PageChanged extends NavigationState {
  final int selectedIndex;

  const PageChanged({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}

part of 'bottom_navigation_bloc.dart';

// States
class NavigationState extends Equatable {
  final int selectedIndex;

  const NavigationState(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}

class PageChanged extends NavigationState {
  const PageChanged(super.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

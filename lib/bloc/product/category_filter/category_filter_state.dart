part of 'category_filter_bloc.dart';

sealed class CategoryFilterState extends Equatable {
  const CategoryFilterState(this.selectedCategory);

  final WineCategory? selectedCategory;

  @override
  List<Object> get props => [selectedCategory!];

  bool isSelected(WineCategory category) => selectedCategory == category;
}

class CategoryFilterInitial extends CategoryFilterState {
  const CategoryFilterInitial() : super(null);
}

class CategoryFilterChanged extends CategoryFilterState {
  const CategoryFilterChanged(super.selectedCategory);
}

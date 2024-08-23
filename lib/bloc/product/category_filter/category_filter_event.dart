part of 'category_filter_bloc.dart';

sealed class CategoryFilterEvent extends Equatable {
  const CategoryFilterEvent();

  @override
  List<Object> get props => [];
}

class CategoryFilterTap extends CategoryFilterEvent {
  final WineCategory selectedCategory;

  const CategoryFilterTap(this.selectedCategory);

  @override
  List<Object> get props => [selectedCategory];
}
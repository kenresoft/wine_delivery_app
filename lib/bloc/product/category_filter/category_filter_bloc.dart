import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../utils/enums.dart';

part 'category_filter_event.dart';
part 'category_filter_state.dart';

class CategoryFilterBloc extends Bloc<CategoryFilterEvent, CategoryFilterState> {
  CategoryFilterBloc() : super(const CategoryFilterInitial()) {
    on<CategoryFilterTap>((event, emit) {
      emit(CategoryFilterChanged(event.selectedCategory));
    });
  }
}

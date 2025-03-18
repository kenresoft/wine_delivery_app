/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/views/product/category/products_category_screen.dart';

import '../../../bloc/category/category_filter/category_filter_bloc.dart';
import '../../../bloc/category/category_list/wines_bloc.dart';
import '../../../model/enums/wine_category.dart';
import '../../../model/product.dart';

class ProductsCategoryAppBar extends StatefulWidget {
  final BuildContext context;
  final WinesState state;
  final List<Product> filteredWines;

  const ProductsCategoryAppBar({
    super.key,
    required this.context,
    required this.state,
    required this.filteredWines,
  });

  @override
  State<ProductsCategoryAppBar> createState() => _ProductsCategoryAppBarState();
}

class _ProductsCategoryAppBarState extends State<ProductsCategoryAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        '${_selectedCategory.displayName} Wines',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: WineSearchDelegate(
                wines: widget.state.wines,
                onSearch: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _showFilters(context),
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => _showSortOptions(context, widget.filteredWines),
        ),
      ],
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 450,
          padding: const EdgeInsets.all(16.0),
          child: _buildFilterOptions(context),
        );
      },
    );
  }

  Column _buildFilterOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter by:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<CategoryFilterBloc, CategoryFilterState>(
          builder: (context, state) {
            return DropdownButton<WineCategory>(
              value: state.selectedCategory,
              menuWidth: 300,
              items: WineCategory.values.map((category) {
                return DropdownMenuItem<WineCategory>(
                  onTap: () => context.read<CategoryFilterBloc>().add(CategoryFilterTap(category)),
                  value: category,
                  child: Text(category.displayName), // Assuming .toString() works for WineCategory
                );
              }).toList(),
              onChanged: (newValue) {
                if (!widget.applyFiltersOnChange) {
                  _selectedCategory = newValue!;
                } else {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                }
              },
              isExpanded: true,
              hint: const Text('Select a Category'),
            );
          },
        ),
        const SizedBox(height: 16),
        CategoryFilterSlider(
          label: 'Price Range',
          min: 0,
          max: CategoryScreen.priceMax,
          currentMin: _minPrice,
          currentMax: _maxPrice,
          onChanged: (newValue) {
            if (!widget.applyFiltersOnChange) {
              _minPrice = newValue.start;
              _maxPrice = newValue.end;
            } else {
              setState(() {
                _minPrice = newValue.start;
                _maxPrice = newValue.end;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        CategoryFilterSlider(
          label: 'Rating Range',
          min: 0,
          max: CategoryScreen.ratingMax,
          currentMin: _minRating,
          currentMax: _maxRating,
          onChanged: (newValue) {
            if (!widget.applyFiltersOnChange) {
              _minRating = newValue.start;
              _maxRating = newValue.end;
            } else {
              setState(() {
                _minRating = newValue.start;
                _maxRating = newValue.end;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        CategoryFilterSlider(
          label: 'Alcohol Content (%)',
          min: 0,
          max: CategoryScreen.alcoholMax,
          currentMin: _minAlcoholContent,
          currentMax: _maxAlcoholContent,
          onChanged: (newValue) {
            if (!widget.applyFiltersOnChange) {
              _minAlcoholContent = newValue.start;
              _maxAlcoholContent = newValue.end;
            } else {
              setState(() {
                _minAlcoholContent = newValue.start;
                _maxAlcoholContent = newValue.end;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              if (!widget.applyFiltersOnChange) {
                _applyFilters();
              }
              //Navigator.pop(context);
            },
            child: const Text('Apply Filters'),
          ),
        ),
      ],
    );
  }

  void _showSortOptions(BuildContext context, List<Product> filteredWines) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort by:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildSortOption('Name (A-Z)', filteredWines),
              _buildSortOption('Popularity', filteredWines),
              _buildSortOption('Price', filteredWines),
              _buildSortOption('Rating', filteredWines),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String sortOption, List<Product> filteredWines) {
    String displayText = sortOption;

    // Update the label for Name sorting based on the current order
    if (sortOption == 'Name (A-Z)' || sortOption == 'Name (Z-A)') {
      displayText = _isAscending ? 'Name (A-Z)' : 'Name (Z-A)';
    }

    return ListTile(
      title: Text(
        displayText,
        style: TextStyle(
          fontSize: 16,
          fontWeight: _selectedSort == sortOption ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: _selectedSort == sortOption
          ? Icon(
        _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
        color: Colors.amber,
      )
          : null,
      onTap: () {
        _onTapSortOption(sortOption, filteredWines);
      },
    );
  }

  _onTapSortOption(String sortOption, List<Product> filteredWines) {
    setState(() {
      if (_selectedSort == sortOption) {
        // Toggle sort order if the same option is selected
        _isAscending = !_isAscending;
      } else {
        // Set new sort option and default to ascending order
        _selectedSort = sortOption;
        _isAscending = true;
      }
      _applySorting(filteredWines);
    });
    Navigator.pop(context);
  }
}
*/

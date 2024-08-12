import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/bloc/category/category_list/wines_bloc.dart';
import 'package:wine_delivery_app/model/enums/wine_category.dart';

import '../../bloc/category/category_filter/category_filter_bloc.dart';
import '../../model/wine.dart';

class CategoryScreen extends StatefulWidget {
  static const priceMax = 50.0;
  static const ratingMax = 10.0;
  static const alcoholMax = 20.0;

  final bool applyFiltersOnChange;

  const CategoryScreen({
    super.key,
    //this.wines,
    this.applyFiltersOnChange = true, // Default to true
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late WineCategory _selectedCategory;
  late WinesBloc bloc;

  String _searchQuery = '';
  String _selectedSort = 'Popularity';
  double _minPrice = 0;
  double _maxPrice = CategoryScreen.priceMax;
  double _minRating = 0;
  double _maxRating = CategoryScreen.ratingMax;
  double _minAlcoholContent = 0;
  double _maxAlcoholContent = CategoryScreen.alcoholMax;

  @override
  void initState() {
    super.initState();
    _selectedCategory = WineCategory.rose;
    bloc = context.read<WinesBloc>();
    bloc.add(WinesReady());
  }

  void _applyFilters() {
    setState(() {
      // Mark filters as applied
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = bloc.state;

    List<Wine> filteredWines = state.wines.where((wine) {
      return wine.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          wine.category.displayName == _selectedCategory.displayName &&
          wine.price >= _minPrice &&
          wine.price <= _maxPrice &&
          wine.rating >= _minRating &&
          wine.rating <= _maxRating &&
          wine.alcoholContent >= _minAlcoholContent &&
          wine.alcoholContent <= _maxAlcoholContent;
    }).toList();

    switch (_selectedSort) {
      case 'Price':
        filteredWines.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Rating':
        filteredWines.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Name (A-Z)':
        filteredWines.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name (Z-A)':
        filteredWines.sort((a, b) => b.name.compareTo(a.name));
        break;
      default:
        filteredWines.sort((a, b) => b.popularity.compareTo(a.popularity));
    }

    return Scaffold(
      appBar: AppBar(
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
                  wines: state.wines,
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
            onPressed: () {
              _showFilters(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortOptions(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: switch ((state.isLoading, state.hasError)) {
          (true, _) => const Center(child: CircularProgressIndicator()),
          (false, true) => Center(child: Text('Error Loading Stock! ${state.errorMessage}')),
          (false, false) => condition(
              filteredWines.isNotEmpty,
              ListView.builder(
                itemCount: filteredWines.length,
                itemBuilder: (context, index) {
                  final wine = filteredWines[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WineDetailScreen(wine: wine),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            child: Hero(
                              tag: wine.image,
                              transitionOnUserGestures: true,
                              child: Image.asset(
                                wine.image,
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wine.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${wine.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.amber[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Rating: ${wine.rating.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    wine.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Center(
                child: Text(
                  'No wines match your search or filter criteria.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          // Implement navigation logic here
        },
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 450,
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
          ),
        );
      },
    );
  }

  void _showSortOptions(BuildContext context) {
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
              _buildSortOption('Name (A-Z)'),
              _buildSortOption('Name (Z-A)'),
              _buildSortOption('Popularity'),
              _buildSortOption('Price'),
              _buildSortOption('Rating'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String sortOption) {
    return ListTile(
      title: Text(
        sortOption,
        style: TextStyle(
          fontSize: 16,
          fontWeight: _selectedSort == sortOption ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: _selectedSort == sortOption ? const Icon(Icons.check, color: Colors.amber) : null,
      onTap: () {
        setState(() {
          _selectedSort = sortOption;
        });
        Navigator.pop(context);
      },
    );
  }

}

class CategoryFilterSlider extends StatefulWidget {
  final String label;
  final double min;
  final double max;
  final double currentMin;
  final double currentMax;
  final ValueChanged<RangeValues> onChanged;

  const CategoryFilterSlider({
    super.key,
    required this.label,
    required this.min,
    required this.max,
    required this.currentMin,
    required this.currentMax,
    required this.onChanged,
  });

  @override
  State<CategoryFilterSlider> createState() => _CategoryFilterSliderState();
}

class _CategoryFilterSliderState extends State<CategoryFilterSlider> {
  late RangeValues _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = RangeValues(widget.currentMin, widget.currentMax);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.label}: \$${_currentRange.start.toStringAsFixed(0)} - \$${_currentRange.end.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        RangeSlider(
          min: widget.min,
          max: widget.max,
          values: _currentRange,
          onChanged: (newRange) {
            setState(() {
              _currentRange = newRange;
            });
            widget.onChanged(newRange);
          },
        ),
      ],
    );
  }
}


class WineSearchDelegate extends SearchDelegate<String> {
  final List<Wine> wines;
  final ValueChanged<String> onSearch;

  WineSearchDelegate({
    required this.wines,
    required this.onSearch,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = wines.where((wine) {
      return wine.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No matching wines found',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final wine = results[index];
        return ListTile(
          title: Text(wine.name),
          subtitle: Text('\$${wine.price.toStringAsFixed(2)}'),
          onTap: () {
            close(context, wine.name);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WineDetailScreen(wine: wine),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = wines.where((wine) {
      return wine.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final wine = suggestions[index];
        return ListTile(
          title: Text(wine.name),
          subtitle: Text('\$${wine.price.toStringAsFixed(2)}'),
          onTap: () {
            query = wine.name;
            showResults(context);
          },
        );
      },
    );
  }
}

class WineDetailScreen extends StatelessWidget {
  final Wine wine;

  const WineDetailScreen({super.key, required this.wine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wine.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: wine.image,
              child: Image.asset(
                wine.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              wine.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${wine.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.amber[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rating: ${wine.rating.toStringAsFixed(1)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Alcohol Content: ${wine.alcoholContent.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              wine.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

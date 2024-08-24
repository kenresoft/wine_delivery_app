import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/model/enums/wine_category.dart';

import '../../../bloc/product/category_filter/category_filter_bloc.dart';
import '../../../bloc/product/category_list/wines_bloc.dart';
import '../../../model/product.dart';
import '../../../repository/popularity_repository.dart';
import '../../../repository/similar_wines_repository.dart';
import '../product_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  static const double priceMax = 50.0;
  static const double ratingMax = 10.0;
  static const double alcoholMax = 20.0;

  final bool applyFiltersOnChange;
  final WineCategory? category;

  const CategoryScreen({
    super.key,
    this.applyFiltersOnChange = true,
    this.category, // Default to true
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

  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category ?? WineCategory.rose;
    bloc = context.read<WinesBloc>();
    bloc.add(WinesReady());
  }

  void _applyFilters() {
    setState(() {
      // Mark filters as applied
    });
  }

  /*@override
  Widget build(BuildContext context) {
    final state = bloc.state;

    List<Product> filteredWines = state.wines.where((wine) {
      return wine.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          wine.category.name == _selectedCategory.displayName &&
          wine.price >= _minPrice &&
          wine.price <= _maxPrice &&
          wine.rating >= _minRating &&
          wine.rating <= _maxRating &&
          wine.alcoholContent >= _minAlcoholContent &&
          wine.alcoholContent <= _maxAlcoholContent;
    }).toList();

    _applySorting(filteredWines);
    return Scaffold(
      appBar: _buildAppBar(context, state, filteredWines),
      body: BlocBuilder<WinesBloc, WinesState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildBody(state, filteredWines),
          );
        },
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    final state = bloc.state;

    List<Product> filteredWines = state.wines.where((wine) {
      return wine.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          wine.category.name == 'roses' /*'Non-Alcoholic'*//*_selectedCategory.displayName*/ /*&&
          wine.price >= _minPrice &&
          wine.price <= _maxPrice &&
          _calculateAverageRating(wine.reviews) >= _minRating &&
          _calculateAverageRating(wine.reviews) <= _maxRating &&
          wine.alcoholContent >= _minAlcoholContent &&
          wine.alcoholContent <= _maxAlcoholContent*/;
    }).toList();

    _applySorting(filteredWines);

    return Scaffold(
      appBar: _buildAppBar(context, state, filteredWines),
      body: BlocBuilder<WinesBloc, WinesState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildBody(state, filteredWines),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, WinesState state, List<Product> filteredWines) {
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
          onPressed: () => _showFilters(context),
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => _showSortOptions(context, filteredWines),
        ),
      ],
    );
  }

  Widget _buildBody(WinesState state, List<Product> filteredWines) {
    return switch ((state.isLoading, state.hasError)) {
      (true, _) => const Center(child: CircularProgressIndicator()),
      (false, true) => Center(child: Text('Error Loading Stock! ${state.errorMessage}')),
      (false, false) => condition(
          filteredWines.isNotEmpty,
          ListView.builder(
            itemCount: filteredWines.length,
            itemBuilder: (context, index) {
              final wine = filteredWines[index];
              return _buildWineCard(wine);
            },
          ),
          const Center(
            child: Text(
              'No wines match your search or filter criteria.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
    };
  }

  Widget _buildWineCard(Product wine) {
    final Map<String, int> purchaseCountMap = {
      'Côtes de Provence Rosé': 120,
      'Cremant d\'Alsace': 95,
      'Lambrusco': 85,
      'Cabernet Franc Rosé': 150,
      'Crémant de Loire': 110,
      'Syrah': 70,
      'Syrah Rosé': 60,
      'Vermouth': 140,
      'Sauvignon Blanc': 130,
      'Nebbiolo': 200,
      'Cava': 90,
      'Banyuls': 100,
    };

    final Map<String, int> reviewCountMap = {
      'Côtes de Provence Rosé': 75,
      'Cremant d\'Alsace': 65,
      'Lambrusco': 50,
      'Cabernet Franc Rosé': 95,
      'Crémant de Loire': 80,
      'Syrah': 40,
      'Syrah Rosé': 35,
      'Vermouth': 100,
      'Sauvignon Blanc': 90,
      'Nebbiolo': 120,
      'Cava': 60,
      'Banyuls': 55,
    };


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              wine: wine,
              similarWinesRepo: SimilarWinesRepository(allWines: []),
              popularityRepo: PopularityRepository(
                purchaseCountMap: purchaseCountMap,
                reviewCountMap: reviewCountMap,
              ),
            ),
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
            _buildWineImage(wine),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildWineDetails(wine),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildWineImage(Product wine) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
      child: Hero(
        tag: wine.image,
        transitionOnUserGestures: true,
        child: Image.asset(
          'assets/images/${wine.image}',
          height: 100,
          width: 100,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildWineDetails(Product wine) {
    return Column(
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
          'Rating: ${_calculateAverageRating(wine.reviews).toStringAsFixed(1)}',
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
    );
  }

  /*void _applySorting(List<Product> filteredWines) {
    setState(() {
      switch (_selectedSort) {
        case 'Price':
          filteredWines.sort((a, b) => _isAscending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
          break;
        case 'Rating':
          filteredWines.sort((a, b) => _isAscending ? a.rating.compareTo(b.rating) : b.rating.compareTo(a.rating));
          break;
        case 'Name (A-Z)':
        case 'Name (Z-A)':
          filteredWines.sort((a, b) => _isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
          break;
        case 'Reviews':
          filteredWines.sort((a, b) => _isAscending ? a.reviews.length.compareTo(b.reviews.length) : b.reviews.length.compareTo(a.reviews.length));
          break;
        default:
          // Default sorting logic
          filteredWines.sort((a, b) => _isAscending ? a.rating.compareTo(b.rating) : b.rating.compareTo(a.rating));
      }
    });
  }*/

  void _applySorting(List<Product> filteredWines) {
    setState(() {
      switch (_selectedSort) {
        case 'Price':
          filteredWines.sort((a, b) => _isAscending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
          break;
        case 'Rating':
          filteredWines.sort((a, b) =>
              _isAscending ? _calculateAverageRating(a.reviews).compareTo(_calculateAverageRating(b.reviews)) : _calculateAverageRating(b.reviews).compareTo(_calculateAverageRating(a.reviews)));
          break;
        case 'Name (A-Z)':
        case 'Name (Z-A)':
          filteredWines.sort((a, b) => _isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
          break;
        case 'Reviews':
          filteredWines.sort((a, b) => _isAscending ? a.reviews.length.compareTo(b.reviews.length) : b.reviews.length.compareTo(a.reviews.length));
          break;
        default:
          // Default sorting logic
          filteredWines.sort((a, b) =>
              _isAscending ? _calculateAverageRating(a.reviews).compareTo(_calculateAverageRating(b.reviews)) : _calculateAverageRating(b.reviews).compareTo(_calculateAverageRating(a.reviews)));
      }
    });
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    final totalRating = reviews.fold<double>(0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
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
  final List<Product> wines;
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
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WineDetailScreen(wine: wine),
              ),
            );*/
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


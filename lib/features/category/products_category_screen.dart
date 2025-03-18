import 'package:badges/badges.dart' as badges;
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/theme/themes.dart';
import 'package:vintiora/core/utils/extensions.dart';
import 'package:vintiora/core/utils/utils.dart';
import 'package:vintiora/features/category/domain/enums/wine_category.dart';
import 'package:vintiora/features/home/presentation/pages/main_screen.dart';
import 'package:vintiora/features/product/data/models/responses/product.dart';
import 'package:vintiora/features/product/data/models/responses/reviews.dart';
import 'package:vintiora/features/product/presentation/bloc/category_filter/category_filter_bloc.dart';
import 'package:vintiora/features/product/presentation/bloc/category_list/wines_bloc.dart';
import 'package:vintiora/shared/widgets/rate_bar.dart';

import '../product/product_detail_screen.dart';
import '../product/product_search.dart';

class CategoryScreen extends StatefulWidget {
  static const double priceMax = 5000.0;
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
    context.read<WinesBloc>().add(WinesReady());
  }

  void _applyFilters() {
    setState(() {
      // Apply filters and trigger a rebuild
    });
  }

  void _applySorting(List<Product> filteredWines) {
    //setState(() {
    switch (_selectedSort) {
      case 'Price':
        filteredWines.sort((a, b) => _isAscending ? a.defaultPrice!.compareTo(b.defaultPrice!) : b.defaultPrice!.compareTo(a.defaultPrice!));
        break;
      case 'Rating':
        filteredWines.sort(
            (a, b) => _isAscending ? calculateAverageRating(a.reviews).compareTo(calculateAverageRating(b.reviews)) : calculateAverageRating(b.reviews).compareTo(calculateAverageRating(a.reviews)));
        break;
      case 'Name (A-Z)':
      case 'Name (Z-A)':
        filteredWines.sort((a, b) => _isAscending ? a.name!.compareTo(b.name!) : b.name!.compareTo(a.name!));
        break;
      case 'Reviews':
        filteredWines.sort((a, b) => _isAscending ? a.reviews!.length.compareTo(b.reviews!.length) : b.reviews!.length.compareTo(a.reviews!.length));
        break;
      default:
        // Default sorting logic
        filteredWines.sort(
            (a, b) => _isAscending ? calculateAverageRating(a.reviews).compareTo(calculateAverageRating(b.reviews)) : calculateAverageRating(b.reviews).compareTo(calculateAverageRating(a.reviews)));
    }
    //});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WinesBloc, WinesState>(
      builder: (context, state) {
        List<Product> filteredWines = state.wines.where((wine) {
          return wine.name!.toLowerCase().contains(_searchQuery.toLowerCase()) &&
              wine.category?.name! == _selectedCategory.displayName &&
              wine.defaultPrice! >= _minPrice &&
              wine.defaultPrice! <= _maxPrice &&
              calculateAverageRating(wine.reviews) >= _minRating &&
              calculateAverageRating(wine.reviews) <= _maxRating &&
              wine.alcoholContent! >= _minAlcoholContent &&
              wine.alcoholContent! <= _maxAlcoholContent;
        }).toList();

        _applySorting(filteredWines);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            // BlocProvider.of<NavigationBloc>(context).add(const PageTapped(0));
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return const MainScreen();
                },
              ),
            );
          },
          child: Scaffold(
            appBar: _buildAppBar(context, state, filteredWines),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildBody(state, filteredWines),
            ),
          ),
        );
      },
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
              delegate: ProductSearch(products: state.wines),
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

Widget buildBody(WinesState state, List<Product> filteredWines) {
  return switch ((state.isLoading, state.hasError)) {
    (true, _) => const Center(child: CircularProgressIndicator()),
    (false, true) => Center(child: Text('Error Loading Stock! ${state.errorMessage}')),
    (false, false) => condition(
        filteredWines.isNotEmpty,
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: filteredWines.length,
          itemBuilder: (context, index) {
            final wine = filteredWines[index];
            return buildWineCard(context, wine);
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

Widget buildWineCard(BuildContext context, Product wine) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(
            product: wine,
          ),
        ),
      );
    },
    child: SizedBox(
      height: 180,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          children: [
            Row(
              children: [
                // Wine Image with Badges
                buildWineImage(context, wine),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8, right: 18, top: 4),
                    child: buildWineDetails(context, wine),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            // New Product Badge
            if (wine.isNewArrival!) // Assuming 'isNewArrival' is a property of the Product model
              Positioned(
                top: 8,
                left: 8,
                child: badges.Badge(
                  badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: color(context).tertiaryColor,
                    shape: badges.BadgeShape.instagram,
                  ),
                  badgeContent: const Text(
                    'NEW',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),

            // Stock Status Badge
            Positioned(
              top: 0,
              right: 0,
              child: badges.Badge(
                badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Utils.getStockStatusColor(wine.stockStatus!), // Get color based on stock status
                  shape: badges.BadgeShape.square,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8)),
                ),
                badgeContent: Text(
                  wine.stockStatus!, // Display the stock status text
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildWineImage(BuildContext context, Product wine) {
  return ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: 110,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4).copyWith(top: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color(context).primaryContainerColor),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 85,
              maxWidth: 85,
              minHeight: 100,
            ),
            child: Hero(
              tag: wine.id!,
              transitionOnUserGestures: true,
              child: Image(
                image: Utils.networkImage(wine.image),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildWineDetails(BuildContext context, Product wine) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wine.name!,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(child: const SizedBox(height: 8)),
            Text(
              '\$${wine.defaultPrice!.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.amber[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(child: const SizedBox(height: 8)),
            /*Text(
                'Rating: ${_calculateAverageRating(wine.reviews).toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),*/
            RateBar(rating: calculateAverageRating(wine.reviews)),
          ],
        ),
      ),
      // Spacer(),
      SizedBox(
        height: 45,
        child: Column(
          children: [
            Flexible(
              child: Text(
                wine.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  // height: 1.5,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      // const SizedBox(height: 8),
    ],
  );
}

double calculateAverageRating(List<Reviews>? reviews) {
  if (reviews!.isEmpty) return 0.0;
  final totalRating = reviews.fold<double>(0, (sum, review) => sum + review.rating!);
  return totalRating / reviews.length;
}
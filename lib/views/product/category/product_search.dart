import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/product/favorite/favs_bloc.dart';
import '../../model/product.dart';
import '../../utils/themes.dart';
import 'category/products_category_screen.dart';

class ProductSearch extends SearchDelegate<List<({int cartQuantity, Product product})>> {
  final List<Product> products;
  bool _hasInitialized = false;

  ProductSearch({required this.products});

  @override
  void showResults(BuildContext context) {
    if (!_hasInitialized) {
      _hasInitialized = true;
      BlocProvider.of<FavsBloc>(context).add(LoadFavs()); // Trigger loading once
    }
    super.showResults(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Theme(
        data: theme(context),
        child: IconButton(
          icon: const Icon(CupertinoIcons.clear),
          onPressed: () {
            query = '';
            FocusManager.instance.primaryFocus!.unfocus();
          },
        ),
      ),
      // const SizedBox(width: 5)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: const Icon(CupertinoIcons.chevron_left),
      onPressed: () => finish(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return theme(context).copyWith(
      textTheme: theme(context).textTheme.copyWith(
            titleLarge: TextStyle(fontSize: 14, height: 1, letterSpacing: 1),
          ),
      inputDecorationTheme: theme(context).inputDecorationTheme.copyWith(
            constraints: const BoxConstraints(maxHeight: 36),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            fillColor: colorScheme(context).surfaceDim,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: color(context).onSurfaceTextColor),
            ),
          ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> suggestionList;
    if (query.isEmpty) {
      suggestionList = products;
    } else {
      suggestionList = products.where(
        (product) {
          return product.name!.toLowerCase().contains(query.toLowerCase()) || product.tags!.contains(query);
        },
      ).toList();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final product = suggestionList[index];
        return buildWineCard(context, product);
      },
    );
  }

  finish(BuildContext context) => Navigator.pop(context);
}

/*class WineSearchDelegate extends SearchDelegate<String> {
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
      return wine.name!.toLowerCase().contains(query.toLowerCase());
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
          title: Text(wine.name!),
          subtitle: Text('\$${wine.defaultPrice!.toStringAsFixed(2)}'),
          onTap: () {
            close(context, wine.name!);
            */ /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WineDetailScreen(wine: wine),
              ),
            );*/ /*
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = wines.where((wine) {
      return wine.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final wine = suggestions[index];
        return ListTile(
          title: Text(wine.name!),
          subtitle: Text('\$${wine.defaultPrice!.toStringAsFixed(2)}'),
          onTap: () {
            query = wine.name!;
            showResults(context);
          },
        );
      },
    );
  }
}*/

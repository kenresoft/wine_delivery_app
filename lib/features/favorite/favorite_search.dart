import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/theme/themes.dart';
import 'package:vintiora/features/product/domain/entities/product_entity.dart';
// import 'package:vintiora/features/product/data/models/responses/product.dart';
import 'package:vintiora/features/product/presentation/bloc/favorite/favs_bloc.dart';

import 'favorites_screen.dart';

class FavoritesSearch extends SearchDelegate<List<({int cartQuantity, Product product})>> {
  final List<({int cartQuantity, Product product})> favorites;
  bool _hasInitialized = false;

  FavoritesSearch(this.favorites);

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
    List<({int cartQuantity, Product product})> suggestionList;
    if (query.isEmpty) {
      suggestionList = favorites;
    } else {
      suggestionList = favorites.where(
        (favorite) {
          return favorite.product.name.toLowerCase().contains(query.toLowerCase()) || favorite.product.tags.contains(query);
        },
      ).toList();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final product = suggestionList[index].product;
        final cartQuantity = suggestionList[index].cartQuantity;
        return buildProductTile(context, product, cartQuantity, true);
      },
    );
  }

  finish(BuildContext context) => Navigator.pop(context);
}

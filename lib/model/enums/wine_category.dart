import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum WineCategory {
  red,
  white,
  rose,
  sparkling,
  dessert,
  fortified,
  organic,
  biodynamic,
  natural,
  kosher,
  lowSulfur,
  nonAlcoholic,
  vegan,
}

extension WineCategoryExtension on WineCategory {
  String get displayName {
    return switch (this) {
      WineCategory.red => 'Red',
      WineCategory.white => 'White',
      WineCategory.rose => 'Rosé',
      WineCategory.sparkling => 'Sparkling',
      WineCategory.dessert => 'Dessert',
      WineCategory.fortified => 'Fortified',
      WineCategory.organic => 'Organic',
      WineCategory.biodynamic => 'Biodynamic',
      WineCategory.natural => 'Natural',
      WineCategory.kosher => 'Kosher',
      WineCategory.lowSulfur => 'Low Sulfur',
      WineCategory.nonAlcoholic => 'Non-Alcoholic',
      WineCategory.vegan => 'Vegan',
    };
  }

  IconData get icon {
    return switch (this) {
      WineCategory.red => Icons.local_bar,
      WineCategory.white => Icons.wine_bar,
      WineCategory.rose => Icons.local_drink,
      WineCategory.sparkling => Icons.bubble_chart,
      WineCategory.dessert => Icons.cake,
      WineCategory.fortified => Icons.wine_bar,
      WineCategory.organic => Icons.eco,
      WineCategory.biodynamic => Icons.grass,
      WineCategory.natural => Icons.nature,
      WineCategory.kosher => CupertinoIcons.staroflife,
      WineCategory.lowSulfur => Icons.filter_alt,
      WineCategory.nonAlcoholic => Icons.no_drinks,
      WineCategory.vegan => CupertinoIcons.tree,
    };
  }
}

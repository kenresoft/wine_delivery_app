import 'package:flutter/material.dart';

import '../../model/enums/wine_category.dart';
import '../product/category/products_category_screen.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    const categories = WineCategory.values;
    final displayedCategories = _showAll ? categories : categories.take(4).toList();

    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            Icon(Icons.category_rounded, color: Colors.amber[800]),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemCount: displayedCategories.length,
          itemBuilder: (context, index) {
            final category = displayedCategories[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    //context.read<WinesBloc>().add(WinesReady());
                    return CategoryScreen(category: category); // Your CategoryScreen widget
                  },
                ),
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category.icon, size: 50, color: Colors.amber[800]),
                    const SizedBox(height: 10),
                    Text(
                      category.displayName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            setState(() {
              _showAll = !_showAll;
            });
          },
          child: Text(_showAll ? 'View Less' : 'View All'),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/utils/extensions.dart';

import '../../utils/enums.dart';
import '../../utils/themes.dart';
import '../category/products_category_screen.dart';

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
            Text(
              'Categories',
              style: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5.w),
            Icon(Icons.category_rounded, color: colorScheme(context).tertiary),
          ],
        ),
        SizedBox(height: 10.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.r,
            crossAxisSpacing: 10.r,
            childAspectRatio: 3.w / 2.h,
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
                // color: color(context).surfaceTintColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category.icon, size: 50.r, color: color(context).onSurfaceTextColor),
                    SizedBox(height: 10.h),
                    Text(
                      category.displayName,
                      style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 10.h),
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
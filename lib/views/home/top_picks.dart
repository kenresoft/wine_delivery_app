import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/utils/helpers.dart';

import '../../utils/themes.dart';

class TopPicksSection extends StatefulWidget {
  const TopPicksSection({super.key});

  @override
  State<TopPicksSection> createState() => _TopPicksSectionState();
}

class _TopPicksSectionState extends State<TopPicksSection> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> topPicks = const [
    {"name": "Red Wine", "price": 20.0, "image": "assets/images/wine-2.png"},
    {"name": "White Wine", "price": 25.0, "image": "assets/images/wine-3.png"},
    {"name": "Sparkling Wine", "price": 30.0, "image": "assets/images/wine-4.png"},
  ];

  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = topPicks.map((_) {
      return AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      );
    }).toList();

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start each animation with a varying delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(seconds: i * 1), () {
        if (mounted) {
          _controllers[i].repeat(reverse: false);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Top Picks',
              style: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5.w),
            Icon(Icons.push_pin_rounded, color: colorScheme(context).tertiary),
          ],
        ),
        SizedBox(height: 10.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topPicks.length,
          itemBuilder: (context, index) {
            final item = topPicks[index];
            final controller = _controllers[index];
            final animation = _animations[index];
            return Card(
              elevation: 1,
              // color: colorScheme(context).surfaceContainerHighest,
              color: color(context).surfaceTintColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(70.0),
              ),
              child: Container(
                height: 130.h,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return Container(
                          height: 130.h,
                          width: 130.h,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: colorScheme(context).tertiary.withOpacity(0.3),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/wine-bg.png'),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(controller.value * pi * 2),
                            child: Image.asset(
                              item['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item['name'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 20.w),
                        child: Text(
                          '\$${item['price'].toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme(context).tertiary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

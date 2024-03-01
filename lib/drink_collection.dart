import 'package:flutter/material.dart';

class DrinksCollection extends StatelessWidget {
  const DrinksCollection({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.color,
  });

  final String name;
  final String image;
  final double price;
  final double rating;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0).copyWith(left: index == 0 ? 16 : 0, right: index == 7 ? 16 : 0),
          child: SizedBox(
            width: 150,
            height: 200,
            child: Card(
              color: color,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      image,
                      width: 75,
                      height: 105,
                    ),
                  ),
                  Positioned(
                    top: 95,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(color: Colors.white, fontSize: 19)),
                        const SizedBox(height: 2),
                        Text('\$$price', style: const TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(rating.toString(), style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
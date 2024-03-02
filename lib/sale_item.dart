import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SaleItem extends StatelessWidget {
  const SaleItem({
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
    return Stack(children: [
      Positioned(
        top: 70,
        left: 10,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 20,
          height: 105,
          child: Card(
            color: color,
            child: Padding(
              padding: const EdgeInsets.only(left: 85, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 19)),
                  const SizedBox(height: 2),
                  Text('\$$price', style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 2),
                  buildRatingBar(rating),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Image.asset(
          image,
          height: 155,
        ),
      ),
    ]);
  }

  RatingBar buildRatingBar(double value) {
    return RatingBar.builder(
      itemSize: 15,
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      unratedColor: Colors.white70,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) {
        return const Icon(Icons.star, size: 2, color: Colors.amber);
      },
      onRatingUpdate: (double value) {},
    );
  }
}

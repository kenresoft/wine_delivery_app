import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateBar extends StatelessWidget {
  const RateBar({
    super.key,
    required this.rating,
    required this.index,
  });

  final List<double> rating;
  final int index;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemSize: 15,
      initialRating: rating[index],
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

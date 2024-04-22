import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateBar extends StatelessWidget {
  const RateBar({
    super.key,
    required this.rating,
    this.size = 15,
    this.unratedColor = Colors.white70,
  });

  final double rating;
  final double? size;
  final Color? unratedColor;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemSize: size!,
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      unratedColor: unratedColor,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) {
        return const Icon(Icons.star, size: 2, color: Colors.amber);
      },
      onRatingUpdate: (double value) {},
    );
  }
}

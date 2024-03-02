import 'package:flutter/material.dart';
import 'package:wine_delivery_app/rate_bar.dart';

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
        top: 60,
        left: 10,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 20,
          height: 105,
          child: Card(
            color: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(left: 80, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 19)),
                  const SizedBox(height: 2),
                  Text('\$$price', style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 2),
                  RateBar(rating: rating),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: 15,
        left: -14,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            image,
            height: 155,
            width: 140,
          ),
        ),
      ),
    ]);
  }
}

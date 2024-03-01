import 'package:flutter/material.dart';

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
        top: 50,
        left: 10,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 20,
          height: 120,
          child: Card(
            color: color,
            child: Padding(
              padding: const EdgeInsets.only(left: 110, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 19)),
                  const SizedBox(height: 2),
                  Text('\$$price', style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(rating.toString(), style: const TextStyle(color: Colors.white)),
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
}

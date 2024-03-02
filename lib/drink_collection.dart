import 'package:flutter/material.dart';
import 'package:wine_delivery_app/clipper.dart';
import 'package:wine_delivery_app/rate_bar.dart';

class DrinksCollection extends StatelessWidget {
  const DrinksCollection({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.color,
  });

  final List<String> name;
  final List<String> image;
  final List<double> price;
  final List<double> rating;
  final List<Color> color;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: name.length,
      scrollDirection: Axis.horizontal,
      itemExtent: 175,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(4.0).copyWith(left: index == 0 ? 12 : 6, right: index == name.length - 1 ? 12 : 6),
          child: Stack(children: [
            Positioned(
              top: 50,
              left: 0,
              width: 160,
              height: 200,
              child: Card(
                color: color[index],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name[index], style: const TextStyle(color: Colors.white, fontSize: 18)),
                      const SizedBox(height: 2),
                      Text('\$${price[index]}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(height: 2),
                      buildRatingBar(index),
                      //Text(rating[index].toString(), style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4,
              left: 40,
              child: CustomPaint(
                painter: SemiCircle(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Image.asset(
                  image[index],
                  height: 165,
                  width: 140,
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  RateBar buildRatingBar(int index) {
    return RateBar(rating: rating, index: index);
  }
}

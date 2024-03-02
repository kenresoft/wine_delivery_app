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
      //itemExtent: 180,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          width: 165,
          margin: const EdgeInsets.all(4.0).copyWith(left: index == 0 ? 15 : 4, right: index == name.length - 1 ? 15 : 4),
          child: Stack(children: [
            Positioned(
              top: 50,
              left: 0,
              width: 165,
              height: 200,
              child: Card(
                color: color[index],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                      RateBar(rating: rating[index]),
                      //Text(rating[index].toString(), style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4,
              left: 38,
              child: CustomPaint(
                painter: SemiCircle(),
              ),
            ),
            Positioned(
              left: -3,
              top: 2,
              child: Align(
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
            ),
          ]),
        );
      },
    );
  }
}

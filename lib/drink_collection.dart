import 'package:flutter/material.dart';
import 'package:wine_delivery_app/clippeer.dart';

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
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0).copyWith(left: index == 0 ? 16 : 0, right: index == 7 ? 16 : 0),
          child: Stack(children: [
            Positioned(
              top: 50,
              left: 10,
              child: SizedBox(
                width: 150,
                height: 200,
                child: Card(
                  color: color[index],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name[index], style: const TextStyle(color: Colors.white, fontSize: 19)),
                        const SizedBox(height: 2),
                        Text('\$${price[index]}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(rating[index].toString(), style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                      ],
                    ),
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
                  height: 155,
                  width: 140,
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}

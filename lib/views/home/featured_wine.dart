import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/carousel/carousel_bloc.dart';

class FeaturedWinesCarousel extends StatefulWidget {
  const FeaturedWinesCarousel({super.key});

  @override
  State<FeaturedWinesCarousel> createState() => _FeaturedWinesCarouselState();
}

class _FeaturedWinesCarouselState extends State<FeaturedWinesCarousel> {
  late CarouselController controller;
  late Timer timer;
  late CarouselBloc carouselBloc;

  static const double itemWidth = 350.0;
  static const Duration carouselInterval = Duration(seconds: 5);
  static const Duration animationDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    controller = CarouselController();
    carouselBloc = context.read<CarouselBloc>();

    timer = Timer.periodic(carouselInterval, _autoScrollCarousel);
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();
    super.dispose();
  }

  void _autoScrollCarousel(Timer timer) {
    final state = carouselBloc.state as CarouselPosition;

    int nextItem = (state.currentItem + 1) % 3; // Assuming 3 items in the carousel
    carouselBloc.add(CarouselTap(value: nextItem));
    _animateCarouselTo(nextItem);
  }

  void _animateCarouselTo(int itemIndex) {
    controller.animateTo(itemIndex * itemWidth, duration: animationDuration, curve: Curves.easeInOut);
  }

  void tapCallback(int value) {
    carouselBloc.add(CarouselTap(value: value + 1));
    _animateCarouselTo(value + 1);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: CarouselView(
        controller: controller,
        onTap: tapCallback,
        itemExtent: itemWidth,
        shrinkExtent: 100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        itemSnapping: true,
        backgroundColor: Colors.transparent,
        children: const [
          WineCard(image: "assets/images/wine-3.png", name: "Red Wine"),
          WineCard(image: "assets/images/wine-2.png", name: "White Wine"),
          WineCard(image: "assets/images/wine-4.png", name: "Rosé Wine"),
        ],
      ),
    );
  }
}

class WineCard extends StatelessWidget {
  final String image;
  final String name;

  const WineCard({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: BlocBuilder<CarouselBloc, CarouselState>(
              builder: (context, state) {
                if (state is CarouselPosition) {
                  return Text(
                    '$name ${state.currentItem + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 6.0,
                          color: Colors.black.withOpacity(0.7),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
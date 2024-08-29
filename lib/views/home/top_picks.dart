import 'package:flutter/material.dart';

class TopPicksSection extends StatefulWidget {
  const TopPicksSection({super.key});

  @override
  State<TopPicksSection> createState() => _TopPicksSectionState();
}

class _TopPicksSectionState extends State<TopPicksSection> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> topPicks = const [
    {"name": "Red Wine", "price": 20.0, "image": "assets/images/wine-2.png"},
    {"name": "White Wine", "price": 25.0, "image": "assets/images/wine-3.png"},
    {"name": "Sparkling Wine", "price": 30.0, "image": "assets/images/wine-4.png"},
  ];

  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = topPicks.map((_) {
      return AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      );
    }).toList();

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.75, end: 1.15).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start each animation with a varying delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(seconds: i * 12), () {
        _controllers[i].repeat(reverse: true);
        // TODO: Unhandled Exception: Null check operator used on a null value - Error keeps throwing here
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Top Picks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            Icon(Icons.push_pin_rounded, color: Colors.amber[800]),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topPicks.length,
          itemBuilder: (context, index) {
            final item = topPicks[index];
            final animation = _animations[index];
            return Container(
              height: 130,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(70),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: animation.value,
                            child: child,
                          );
                        },
                        child: Image.asset(
                          item['image'],
                          width: 80,
                          height: 110,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 130,
                        decoration: const BoxDecoration(
                          color: Color(0x6669625d),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 120,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      '\$${item['price'].toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, color: Colors.green),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_delivery_app/bloc/carousel/carousel_bloc.dart';
import 'package:wine_delivery_app/views/category/category_screen.dart';

import '../../bloc/route/route_bloc.dart';
import '../../bloc/route/route_event.dart';
import '../../bloc/route/route_state.dart';
import '../../model/enums/wine_category.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final routerDelegate = Router.of(context).routerDelegate as TabRouterDelegate;
    return Scaffold(
      /*appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Wine Delivery'),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Implement search functionality
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Implement notification functionality
              Navigator.pushNamed(context, 'home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart
            },
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'cart_page'),
            child: Container(
              width: 50,
              height: 50,
              // color: Colors.green,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 24.r, color: const Color(0xff383838)),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      alignment: Alignment.center,
                      width: 16.w,
                      height: 16.w,
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: const Color(0xffBD7879),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: FittedBox(
                        child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
                          return Text(
                            //'${cartManager.cartItems.length}',
                            '${state.cartItems.length}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),*/
      //body: _widgetOptions[_selectedIndex],

      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return const HomePage(); // Your current screen's body
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _getSelectedIndex(context),
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          switch (index) {
            case 0:
              context.read<NavigationBloc>().add(NavigateToHome());
              break;
            case 1:
              context.read<NavigationBloc>().add(NavigateToCategories());
              break;
            case 2:
              context.read<NavigationBloc>().add(NavigateToCart());
              break;
            case 3:
              context.read<NavigationBloc>().add(NavigateToProfile());
              break;
          }
        },
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final state = context.read<NavigationBloc>().state;
    if (state is HomePageState) return 0;
    if (state is CategoriesPageState) return 1;
    if (state is CartPageState) return 2;
    if (state is ProfilePageState) return 3;
    return 0;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeaturedWinesCarousel(),
            SizedBox(height: 20),
            CategoryGrid(),
            SizedBox(height: 10),
            TopPicksSection(),
          ],
        ),
      ),
    );
  }
}

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

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    const categories = WineCategory.values;
    final displayedCategories = _showAll ? categories : categories.take(4).toList();

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemCount: displayedCategories.length,
          itemBuilder: (context, index) {
            final category = displayedCategories[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CategoryScreen(category: category); // Your CategoryScreen widget
                  },
                ),
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category.icon, size: 50, color: Colors.amber[800]),
                    const SizedBox(height: 10),
                    Text(
                      category.displayName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            setState(() {
              _showAll = !_showAll;
            });
          },
          child: Text(_showAll ? 'View Less' : 'View All'),
        ),
      ],
    );
  }
}

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
        duration: const Duration(seconds: 3),
      );
    }).toList();

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.9, end: 1.05).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start each animation with a varying delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(seconds: i * 10), () {
        _controllers[i].repeat(reverse: true);
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
        const Text(
          'Top Picks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

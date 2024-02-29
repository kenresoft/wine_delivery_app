import 'package:circular_image/circular_image.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, toolbarHeight: 0, scrolledUnderElevation: 0),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Stack(
                          children: [
                            const Positioned(
                              left: 40,
                              width: 80,
                              top: 10,
                              child: Card(
                                  color: Colors.grey,
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    'Alex',
                                    style: TextStyle(fontSize: 18, backgroundColor: Colors.transparent),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            ClipOval(
                              child: Card(
                                elevation: 10,
                                color: Colors.red,
                                shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(80)),
                                child: CircularImage(
                                  radius: 28,
                                  source: 'assets/profile.jpg',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.shopping_bag_outlined, size: 30),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// TEXT FIELD

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.white12, blurRadius: 10, offset: Offset(-2, -2)),
                        BoxShadow(color: Colors.white12, blurRadius: 10, offset: Offset(2, -10)),
                      ],
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.black12.withOpacity(.03),
                        filled: true,
                        hintText: 'Search Drinks',
                        suffixIcon: const Card(
                          color: Colors.black,
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white12, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white12, width: 1),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      ),
                    ),
                  ),
                ),

                //SizedBox(height: 10),

                /// TEXT
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Drinks', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Collection', style: TextStyle(fontSize: 30)),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  height: 35,
                  child: DefaultTabController(
                    length: 3,
                    child: TabBar(
                      tabs: const [
                        Text('All'),
                        Text('Trending'),
                        Text('Popular'),
                      ],
                      controller: tabController,
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('On Sale', style: TextStyle(fontSize: 30)),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  height: 200,
                  child: TabBarView(controller: tabController, children: const [
                    DrinksCollection(
                      name: 'Remy Martin',
                      image: 'assets/profile.jpg',
                      price: 28.45,
                      rating: 4,
                      color: Colors.grey,
                    ),
                    DrinksCollection(
                      name: 'Grover',
                      image: 'assets/profile.jpg',
                      price: 16.99,
                      rating: 3.0,
                      color: Colors.purple,
                    ),
                    DrinksCollection(
                      name: 'Sailor',
                      image: 'assets/profile.jpg',
                      price: 28.45,
                      rating: 3.5,
                      color: Colors.redAccent,
                    ),
                  ]),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        height: 120,
                        child: Card(color: Colors.brown),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 50,
                        child: Image.asset(
                          'assets/profile.jpg',
                          height: 70,
                          width: 70,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrinksCollection extends StatelessWidget {
  const DrinksCollection({
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
    return ListView.builder(
      itemCount: 8,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0).copyWith(left: index == 0 ? 16 : 0, right: index == 7 ? 16 : 0),
          child: SizedBox(
            width: 150,
            height: 200,
            child: Card(
              color: color,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      image,
                      width: 75,
                      height: 105,
                    ),
                  ),
                  Positioned(
                    top: 95,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(color: Colors.white, fontSize: 19)),
                        const SizedBox(height: 2),
                        Text('\$$price', style: const TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(rating.toString(), style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

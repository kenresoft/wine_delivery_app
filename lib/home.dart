import 'package:circular_image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:fontresoft/fontresoft.dart';
import 'package:wine_delivery_app/sale_item.dart';

import 'drink_collection.dart';

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

                const SizedBox(height: 25),

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

                const SizedBox(height: 25),

                SizedBox(
                  height: 270,
                  child: TabBarView(controller: tabController, children: const [
                    DrinksCollection(
                      name: [
                        'Remy Martin',
                        'Remy Martin',
                        'Remy Martin',
                        'Remy Martin',
                        'Remy Martin',
                      ],
                      image: [
                        'assets/wine-5.png',
                        'assets/wine-2.png',
                        'assets/wine-3.png',
                        'assets/wine-4.png',
                        'assets/wine-6.png',
                      ],
                      price: [
                        28.45,
                        28.45,
                        28.45,
                        28.45,
                        28.45,
                      ],
                      rating: [
                        4,
                        4,
                        4,
                        4,
                        4,
                      ],
                      color: [
                        Color(0xff3e494d),
                        Color(0xff7E587D),
                        Color(0xffE18182),
                        Colors.blueAccent,
                        Colors.orangeAccent,
                      ],
                    ),
                    DrinksCollection(
                      name: ['Grover'],
                      image: ['assets/wine-2.jpg'],
                      price: [16.99],
                      rating: [3.0],
                      color: [Colors.purple],
                    ),
                    DrinksCollection(
                      name: ['Sailor'],
                      image: ['assets/wine-3.jpg'],
                      price: [28.45],
                      rating: [3.5],
                      color: [Colors.redAccent],
                    ),
                  ]),
                ),

                //const SizedBox(height: 5),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('On Sale', style: TextStyle(fontSize: 30)),
                ),

                const SizedBox(height: 5),

                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    itemCount: 4,
                    itemExtent: MediaQuery.of(context).size.width,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return const SaleItem(
                        name: 'Carpene Malvolti Prosecco',
                        image: 'assets/wine-6.png',
                        price: 17.40,
                        rating: 7,
                        color: Color(0xffC37D7D),
                      );
                    },
                  ),
                ),

                /*Padding(
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        height: 120,
                        child: Card(color: Color(0xffC37D7D)),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 50,
                        child: Image.asset(
                          'assets/wine.png',
                          height: 70,
                          width: 70,
                        ),
                      )
                    ],
                  ),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

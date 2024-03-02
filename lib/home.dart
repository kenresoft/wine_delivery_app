import 'package:circular_image/circular_image.dart';
import 'package:flutter/cupertino.dart';
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
                                ),
                              ),
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

                /// TEXT FIELD

                Container(
                  height: 50,
                  margin:const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.black12.withOpacity(.03),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.white12, blurRadius: 10, offset: Offset(-2, -2)),
                      BoxShadow(color: Colors.white12, blurRadius: 10, offset: Offset(2, -10)),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search Drinks',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.transparent, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.transparent, width: 1),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          ),
                        ),
                      ),
                       SizedBox(
                        width: 50,
                        height: 50,
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          color: Colors.black,
                          child: const Icon(CupertinoIcons.search, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                //SizedBox(height: 10),

                /// TEXT
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Drinks',
                    style: Font.poppins(style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w700)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Collection', style: Font.poppins(style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500))),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 35,
                      width: MediaQuery.of(context).size.width - 80,
                      child: DefaultTabController(
                        length: 3,
                        child: TabBar(
                          dividerHeight: 0,
                          indicatorPadding: const EdgeInsets.only(left: 4, right: 4),
                          indicatorColor: Colors.black,
                          labelColor: Colors.black,
                          labelStyle: Font.poppins(style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          labelPadding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          tabs: const [
                            Text('All'),
                            Text('Trending'),
                            Text('Popular'),
                          ],
                          controller: tabController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 12),
                      child: Row(
                        children: [
                          Text(
                            '2',
                            style: Font.poppins(style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            '/8',
                            style: Font.poppins(style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 270,
                  child: TabBarView(controller: tabController, children: [
                    buildDrinksCollection(),
                    buildDrinksCollection(),
                    buildDrinksCollection(),
                  ]),
                ),

                //const SizedBox(height: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'On Sale',
                        style: Font.poppins(style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 12),
                      child: Row(
                        children: [
                          Text(
                            '1',
                            style: Font.poppins(style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            '/3',
                            style: Font.poppins(style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 5),

                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    itemCount: 4,
                    itemExtent: MediaQuery.of(context).size.width,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return const SaleItem(
                        name: 'Carpene Malvolti Prosecco',
                        image: 'assets/wine-6.png',
                        price: 17.40,
                        rating: 3,
                        color: Color(0xffC37D7D),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DrinksCollection buildDrinksCollection() {
    return const DrinksCollection(
      name: [
        'Remy Martin',
        'Grover',
        'Sailor',
        'Remy Martin',
        'Grover',
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
        16.99,
        16.99,
        28.45,
        28.45,
      ],
      rating: [
        4,
        3,
        3,
        2,
        5,
      ],
      color: [
        Color(0xff3e494d),
        Color(0xff7E587D),
        Color(0xffE18182),
        Colors.blue,
        Colors.orange,
      ],
    );
  }
}

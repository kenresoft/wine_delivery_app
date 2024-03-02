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
  final ScrollController _controller_1 = ScrollController();
  final ScrollController _controller_2 = ScrollController();
  int _currentIndex_1 = 1;
  int _currentIndex_2 = 1;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _controller_1.addListener(_scrollListener_1);
    _controller_2.addListener(_scrollListener_2);
  }

  @override
  void dispose() {
    tabController.dispose();
    _controller_1.removeListener(_scrollListener_1);
    _controller_1.dispose();
    _controller_2.removeListener(_scrollListener_2);
    _controller_2.dispose();
    super.dispose();
  }

  void _scrollListener_1() {
    setState(() {
      _currentIndex_1 = (_controller_1.offset / 165).round() + 1; // Assuming item height is 50
    });
  }

  void _scrollListener_2() {
    setState(() {
      _currentIndex_2 = (_controller_2.offset / MediaQuery.of(context).size.width).round() + 1; // Assuming item height is 50
    });
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
                            Positioned(
                              left: 28,
                              width: 95,
                              top: 10,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(16)),
                                margin: const EdgeInsets.all(10),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Alex',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, backgroundColor: Colors.transparent),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 5,
                              color: Colors.white,
                              shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: CircularImage(
                                  radius: 25,
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
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
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
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: Colors.black,
                            child: const Icon(CupertinoIcons.search, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

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
                          unselectedLabelColor: Colors.black,
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
                            '$_currentIndex_1',
                            style: Font.poppins(style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            '/6',
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
                            '$_currentIndex_2',
                            style: Font.poppins(style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            '/4',
                            style: Font.poppins(style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    itemCount: 4,
                    itemExtent: MediaQuery.of(context).size.width,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: _controller_2,
                    itemBuilder: (context, index) {
                      return const SaleItem(
                        name: 'Carpene Malvolti Prosecco',
                        image: 'assets/wine-10.png',
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
    return DrinksCollection(
      name: const [
        'Remy Martin',
        'Grover',
        'Sailor',
        'Remy Martin',
        'Leo Swiss',
        'Grover',
      ],
      image: const [
        'assets/wine-8.png',
        'assets/wine-9.png',
        'assets/wine-3.png',
        'assets/wine-4.png',
        'assets/wine-6.png',
        'assets/wine-2.png',
      ],
      price: const [
        28.45,
        16.99,
        16.99,
        16.99,
        28.45,
        28.45,
      ],
      rating: const [
        4,
        3,
        3,
        2,
        2,
        5,
      ],
      color: const [
        Color(0xff3e494d),
        Color(0xff7E587D),
        Color(0xffE18182),
        Colors.blue,
        Colors.green,
        Colors.orange,
      ],
      scrollController: _controller_1,
    );
  }
}

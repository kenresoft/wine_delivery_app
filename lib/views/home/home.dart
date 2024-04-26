import 'package:circular_image/circular_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontresoft/fontresoft.dart';
import 'package:wine_delivery_app/bloc/cart/cart_bloc.dart';
import 'package:wine_delivery_app/bloc/cart/cart_state.dart';
import 'package:wine_delivery_app/views/home/sale_item.dart';

import '../../auth_modal.dart';
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
      _currentIndex_1 = (_controller_1.offset / 165.w).round() + 1;
    });
  }

  void _scrollListener_2() {
    setState(() {
      _currentIndex_2 =
          (_controller_2.offset / MediaQuery.of(context).size.width).round() +
              1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF9F6),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w).copyWith(top: 42.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150.w,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 20.w,
                            width: 90.w,
                            top: 3.h,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffF0ECED),
                                borderRadius: BorderRadius.circular(16).r,
                              ),
                              margin: const EdgeInsets.all(10).r,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0.w, top: 2.h, bottom: 2.h),
                                child: Text(
                                  'Alex',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AuthModal();
                              },
                            ),
                            child: Card(
                              elevation: 5.h,
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80).r),
                              child: Padding(
                                padding: const EdgeInsets.all(2).r,
                                child: CircularImage(
                                  radius: 20.r,
                                  source: 'assets/profile.jpg',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'cart_page'),
                      child: Stack(
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 30.r, color: const Color(0xff383838)),
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
                                  borderRadius: BorderRadius.circular(40)),
                              child: FittedBox(
                                child: BlocBuilder<CartBloc, CartState>(
                                  builder: (context, state) {
                                    return Text(
                                      //'${cartManager.cartItems.length}',
                                      '${state.cartItems.length}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 10, color: Colors.white),
                                    );
                                  }
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// TEXT FIELD

              Container(
                height: 45.h,
                margin:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(.03),
                  borderRadius: BorderRadius.circular(12).r,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white12,
                        blurRadius: 10,
                        offset: Offset(-2.w, -2.h)),
                    BoxShadow(
                        color: Colors.white12,
                        blurRadius: 10,
                        offset: Offset(2.w, -10.h)),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 5.h,
                  color: const Color(0xffFBF9FA),
                  surfaceTintColor: const Color(0xffFBF9FA),
                  shadowColor: Colors.white54,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search Drinks',
                            hintStyle: TextStyle(fontSize: 13.sp),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10).r,
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 1.w),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10).r,
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 1.w),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 10.h),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12).r,
                        child: SizedBox(
                          width: 50.w,
                          height: 45.h,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12).r),
                            color: const Color(0xff3F4A4E),
                            child: const Icon(CupertinoIcons.search,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// TEXT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
                child: Text(
                  'Drinks',
                  style: Font.poppins(
                      style: TextStyle(
                          fontSize: 30.sp, fontWeight: FontWeight.w700)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
                child: Text(
                  'Collection',
                  style: Font.poppins(
                      style: TextStyle(
                          fontSize: 25.sp, fontWeight: FontWeight.w500)),
                ),
              ),

              SizedBox(height: 25.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 35.h,
                    width: MediaQuery.of(context).size.width - 80.w,
                    child: DefaultTabController(
                      length: 3,
                      child: TabBar(
                        dividerHeight: 0,
                        indicatorPadding:
                            EdgeInsets.only(left: 4.w, right: 4.w),
                        indicatorColor: Colors.black,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black,
                        labelStyle: Font.poppins(
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w500)),
                        labelPadding:
                            EdgeInsets.only(top: 5.h, left: 20.w, right: 20.w),
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
                    padding: EdgeInsets.only(top: 6.h, right: 12.w),
                    child: Row(
                      children: [
                        Text(
                          '$_currentIndex_1',
                          style: Font.poppins(
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Text(
                          '/6',
                          style: Font.poppins(
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              SizedBox(height: 25.h),

              SizedBox(
                height: 270.h,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
                    child: Text(
                      'On Sale',
                      style: Font.poppins(
                          style: TextStyle(
                              fontSize: 23.sp, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.h, right: 12.w),
                    child: Row(
                      children: [
                        Text(
                          '$_currentIndex_2',
                          style: Font.poppins(
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Text(
                          '/4',
                          style: Font.poppins(
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 180.h,
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
      onClick: (int index, DrinksCollection collection) {
        ///print(collection.name[index]);
        Navigator.of(context)
            .pushNamed('product_page', arguments: (index, collection));
      },
    );
  }
}

/*extension ExtensionName on num {
  double get h => toDouble();

  double get w => toDouble();

  double get sp => toDouble();

  double get r => toDouble();
}

extension ExtensionName2 on EdgeInsets {
  EdgeInsets get h => this;

  EdgeInsets get w => this;

  EdgeInsets get r => this;
}

extension ExtensionName3 on BorderRadius {
  BorderRadius get r => this;
}*/

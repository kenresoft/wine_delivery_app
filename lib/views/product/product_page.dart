import 'package:circular_image/circular_image.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wine_delivery_app/home/drink_collection.dart';
import 'package:wine_delivery_app/home/rate_bar.dart';
import 'package:wine_delivery_app/page_2/product_button.dart';
import 'package:wine_delivery_app/utils/utils.dart';

import '../service/cart_manager.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isFavorite = false;

  List<Color> reviewColors = const [
    Color(0xffDF9191),
    Color(0xff876386),
    Color(0xffECA4A3),
    Color(0xffC17B7A),
    Color(0xff98B5F3),
  ];

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as (int, DrinksCollection)?;
    final int? index = product?.$1;
    final DrinksCollection? drinksCollection = product?.$2;

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xffF4F4F4), toolbarHeight: 0, scrolledUnderElevation: 0),
      backgroundColor: const Color(0xffFfffff),
      body: Center(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: const Color(0xffF4F4F4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(CupertinoIcons.chevron_left)),
                        const Icon(Icons.shopping_bag_outlined, size: 30, color: Color(0xff383838)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 150,
                      child: Column(
                        children: [
                          Container(
                            //height: 335,
                            decoration: const BoxDecoration(
                              color: Color(0xffF4F4F4),
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(90)),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 165,
                                  height: 335,
                                  child: Image.asset('${drinksCollection?.image[index!]}', fit: BoxFit.fitHeight),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Strong', style: TextStyle(fontSize: 21, color: Color(0xff37434A))),
                                    Text(
                                      '${drinksCollection?.name[index!]}',
                                      style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w700),
                                    ),
                                    RateBar(
                                      rating: drinksCollection!.rating[index!],
                                      size: 23,
                                      unratedColor: const Color(0xffBEBEBE),
                                    ),
                                    const SizedBox(height: 21),
                                    ProductButton(
                                      text: '\$${drinksCollection.price[index]}',
                                      color: const Color(0xff394346),
                                      height: 38,
                                      width: 92,
                                      borderRadius: 10,
                                    ),
                                    const SizedBox(height: 21),
                                    const Row(
                                      children: [
                                        ProductButton(
                                          text: '250ML',
                                          color: Colors.white,
                                          height: 42,
                                          width: 100,
                                          borderRadius: 12,
                                          isOutlined: true,
                                        ),
                                        ProductButton(
                                          text: '500ML',
                                          color: Color(0xff394346),
                                          height: 42,
                                          width: 100,
                                          borderRadius: 12,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 250,
                              margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
                              decoration: const BoxDecoration(color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Ingredients', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 13),
                                    child: Text(
                                      'There is no better conversation starter or mood setter than alcohol. '
                                      'But having to leave a party to get more booze, that\'s just bad. '
                                      'But with online alcohol delivery service, anyone can order booze, '
                                      'liquor, or alcohol with an app.',
                                      style: TextStyle(fontSize: 15, color: Color(0xffA2A2A2), fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const Text('Reviews', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 6,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(
                                              left: index == 0 ? 0 : 8,
                                              right: index == 5 ? 0 : 8,
                                            ),
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: index != 5 ? reviewColors[index] : const Color(0xff3E494D),
                                                  width: 1.5,
                                                ),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              padding: const EdgeInsets.all(2),
                                              child: index != 5
                                                  ? CircularImage(
                                                      source: 'assets/profile.jpg',
                                                      radius: 25,
                                                    )
                                                  : const CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor: Color(0xff3E494D),
                                                      child: Icon(Icons.add, color: Colors.white),
                                                    ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              height: 110,
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: const Color(0xff394346),
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 56,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffD2D4D6), width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => setState(() => isFavorite = !isFavorite),
                        child: Icon(
                          isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                          color: const Color(0xffD2D4D6),
                          size: 28,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ProductButton(
                        onPressed: () => addToCartButtonPressed(
                          drinksCollection.name[index],
                          drinksCollection.price[index],
                          1,
                        ),
                        text: ' Add to cart',
                        color: Colors.white,
                        icon: const Icon(Icons.add, color: Colors.black, size: 16),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToCartButtonPressed(String itemName, double itemPrice, int quantity) {
    cartManager.addToCart(itemName, itemPrice, quantity);
    '$itemName added to cart'.toast;

    // Optionally show a snackbar or toast message to confirm item added to cart
  }
}

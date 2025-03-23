import 'package:badges/badges.dart' as badges;
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/router/routes.dart';
import 'package:vintiora/core/theme/themes.dart';
import 'package:vintiora/core/utils/utils.dart';
import 'package:vintiora/features/cart/presentation/bloc/cart/cart_bloc.dart';
import 'package:vintiora/features/product/domain/entities/product_entity.dart';
// import 'package:vintiora/features/product/data/models/responses/product.dart';
import 'package:vintiora/features/product/presentation/bloc/favorite/favs_bloc.dart';

import 'favorite_search.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.current) {
      context.read<FavsBloc>().add(LoadFavs());
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildFavoritesAppBar(context),
      body: BlocBuilder<FavsBloc, FavsState>(
        builder: (context, state) {
          if (state is FavsLoaded) {
            final favorites = state.favorites;
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index].product;
                final cartQuantity = favorites[index].cartQuantity;
                return buildProductTile(context, product, cartQuantity, false);
              },
            );
          } else if (state is FavsError) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  AppBar _buildFavoritesAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Favorites'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            final products = (context.read<FavsBloc>().state as FavsLoaded).favorites;
            search(context, products);
          },
        ),
        /*BlocSelector<CartBloc, CartState, int>(
          selector: (state) {
            if (state is CartLoaded) {
              return state.totalItems;
            }
            return 0;
          },
          builder: (context, cartCount) {
            return IconButton(
              icon: badges.Badge(
                badgeContent: Text(
                  cartCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                showBadge: cartCount > 0,
              ),
              onPressed: () {
                // Navigate to cart or other action
              },
            );
          },
        ),*/
      ],
    );
  }
}

Widget buildProductTile(
  BuildContext context,
  Product product,
  int cartQuantity,
  bool replaceSearchInStack,
) {
  return GestureDetector(
    onTap: () => viewProductDetails(context, product, replaceSearchInStack),
    onLongPress: replaceSearchInStack ? null : () => showProductActions(context, product),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color(context).primaryContainerColor),
      ),
      child: Row(
        children: [
          buildImage(product),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Adjust as needed
              crossAxisAlignment: CrossAxisAlignment.start, // Adjust as needed
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Text(
                        product.name,
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(child: SizedBox(width: 16)),
                    Text(
                      '\$${product.defaultPrice}',
                      maxLines: 1,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Text(product.description, maxLines: 2)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return switch (cartQuantity > 0) {
                  true => badges.Badge(
                      position: badges.BadgePosition.topEnd(
                        top: replaceSearchInStack ? -15 : -8,
                        end: replaceSearchInStack ? -6 : 0,
                      ),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: color(context).holderColor,
                        // borderSide: BorderSide(color: color(context).textColor),
                      ),
                      badgeContent: Container(
                        width: 18,
                        height: 9.5,
                        alignment: Alignment.center,
                        child: Text(
                          cartQuantity.toString(),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 10,
                            height: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: replaceSearchInStack
                          ? Icon(Icons.shopping_cart)
                          : TextButton(
                              style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                              onPressed: () => addToCart(context, product),
                              child: Card(
                                color: color(context).buttonTextColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                  side: BorderSide(color: color(context).textColor),
                                ),
                                child: Container(
                                  width: 60,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Add to Cart',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  false => replaceSearchInStack
                      ? Icon(Icons.shopping_cart)
                      : IconButton(
                          onPressed: () => addToCart(context, product),
                          icon: const Icon(Icons.shopping_cart),
                        ),
                };
              },
            ),
          )
        ],
      ),
    ),
  );
}

Widget buildImage(Product product) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      // side: BorderSide(color: color(context).primaryContainerColor),
    ),
    child: Container(
      margin: EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 80,
          height: 85,
          child: Hero(
            tag: product.id,
            transitionOnUserGestures: true,
            child: AppImage(
              product.image,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    ),
  );
}

void search(
  BuildContext context,
  List<({int cartQuantity, Product product})> favourites,
) {
  showSearch(context: context, delegate: FavoritesSearch(favourites));
}

void addToCart(BuildContext context, Product product) {
  context.read<CartBloc>().add(
        AddToCart(
          productId: product.id,
          quantity: 1,
          cb: () => BlocProvider.of<FavsBloc>(context).add(LoadFavs()),
        ),
      );
}

void viewProductDetails(BuildContext context, Product product, bool replaceSearchInStack) {
  if (replaceSearchInStack) {
    Nav.pushReplace(Routes.productDetails, arguments: product);
  } else {
    Nav.push(Routes.productDetails, arguments: product);
  }
}

void showProductActions(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share Product'),
          onTap: () {
            Navigator.pop(context);
            shareProduct(product);
          },
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Remove from Favorites'),
          onTap: () async {
            await Utils.dialog(
              context,
              title: 'Confirm Remove from Favorites',
              content: 'Are you sure you want to remove this item from your favorites?',
              confirmButtonText: 'Remove',
              onCancel: () => Navigator.pop(context),
              onConfirm: () async {
                BlocProvider.of<FavsBloc>(context).add(ToggleLike(product.id, true));
                Navigator.pop(context);
              },
            );
          },
        )
      ],
    ),
  );
}

void shareProduct(Product product) {
  Utils.shareProduct(
    product.name,
    product.description,
    product.image!,
    product.id,
  );
}

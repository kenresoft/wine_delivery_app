import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/product/favorite/favs_bloc.dart';
import '../../model/product.dart';
import '../../utils/helpers.dart';
import 'product_detail_screen.dart';

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
    BlocProvider.of<FavsBloc>(context).add(LoadFavs());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      BlocProvider.of<FavsBloc>(context).add(LoadFavs());
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
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _search(context),
          ),
        ],
      ),
      body: BlocBuilder<FavsBloc, FavsState>(
        builder: (context, state) {
          if (state is FavsLoaded) {
            final favorites = state.favorites;
            // logger.w(favorites.length);
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index].product;
                final cartQuantity = favorites[index].cartQuantity;
                return _buildProductTile(context, product, cartQuantity);
              },
            );
          } else if (state is FavsError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, Product product, int cartQuantity) {
    return GestureDetector(
      onTap: () => _viewProductDetails(product),
      onLongPress: () => _showProductActions(context, product),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color(context).primaryContainerColor),
        ),
        child: Row(
          children: [
            _buildImage(product),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Adjust as needed
                crossAxisAlignment: CrossAxisAlignment.start, // Adjust as needed
                children: [
                  Text(product.name!),
                  Text(
                    product.description!,
                    maxLines: 2, // Limit subtitle lines if needed
                  ),
                ],
              ),
            ),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return switch (cartQuantity > 0) {
                  true => badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -1, end: 0),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: color(context).holderColor,
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
                      child: IconButton(
                        onPressed: () => _addToCart(product),
                        icon: const Icon(Icons.shopping_cart),
                      ),
                    ),
                  false => IconButton(
                      onPressed: () => _addToCart(product),
                      icon: const Icon(Icons.shopping_cart),
                    ),
                };
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Product product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        // side: BorderSide(color: color(context).primaryContainerColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 95,
          height: 100,
          child: Hero(
            tag: product.id!,
            transitionOnUserGestures: true,
            child: Image(
              image: Utils.networkImage(product.image),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }

  void _search(BuildContext context) {
    showSearch(context: context, delegate: ProductSearchDelegate());
  }

  void _addToCart(Product product) {
    context.read<CartBloc>().add(
          AddToCart(
            productId: product.id!,
            quantity: 1,
            cb: () => BlocProvider.of<FavsBloc>(context).add(LoadFavs()),
          ),
        );
  }

  void _viewProductDetails(Product product) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ProductDetailScreen(product: product);
      },
    ));
  }

  void _showProductActions(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Product'),
            onTap: () {
              Navigator.pop(context);
              _shareProduct(product);
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
                  BlocProvider.of<FavsBloc>(context).add(ToggleLike(product.id!, true));
                  Navigator.pop(context);
                },
              );
            },
          )
        ],
      ),
    );
  }

  void _shareProduct(Product product) {
    Utils.shareProduct(
      product.name!,
      product.description!,
      product.image!,
      product.id!,
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<Product> {
  // Implement search delegate for products
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = '', icon: Icon(Icons.clear))];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, Product()),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results based on query
    return Card();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions
    return Card();
  }
}

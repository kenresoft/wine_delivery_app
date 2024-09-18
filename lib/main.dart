import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/bb.dart';
import 'package:wine_delivery_app/bloc/network/network_bloc.dart';
import 'package:wine_delivery_app/utils/environment_config.dart';

// import 'package:flutter_stripe/flutter_stripe.dart';

import 'bloc/carousel/carousel_bloc.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/navigation/bottom_navigation_bloc.dart';
import 'bloc/order/order_bloc.dart';
import 'bloc/product/category_filter/category_filter_bloc.dart';
import 'bloc/product/category_list/wines_bloc.dart';
import 'bloc/product/favorite/favs/favs_bloc.dart';
import 'bloc/product/favorite/like/like_bloc.dart';
import 'bloc/product/product_bloc.dart';
import 'bloc/profile/profile_bloc.dart';
import 'bloc/promo_code/promo_code_bloc.dart';
import 'bloc/shipment/shipment_bloc.dart';
import 'bloc/shipping_address/shipping_address_bloc.dart';
import 'utils/constants.dart';
import 'utils/themes.dart';
import 'views/admin/oder_management_page.dart';
import 'views/home/home.dart';
import 'views/product/cart/shopping_cart.dart';
import 'views/product/category/products_category_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesService.init();
  await EnvironmentConfig.load(ConfigMode.dev);
  // Stripe.publishableKey = Constants.stripePublishableKey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 825),
      minTextAdapt: true,
      ensureScreenSize: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>(create: (context) => NavigationBloc()),
          BlocProvider<ProductBloc>(create: (context) => ProductBloc()),
          BlocProvider<CartBloc>(create: (context) => CartBloc()),
          BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
          BlocProvider<ShippingAddressBloc>(create: (context) => ShippingAddressBloc()),
          BlocProvider<ShipmentBloc>(create: (context) => ShipmentBloc()),
          BlocProvider<CarouselBloc>(create: (context) => CarouselBloc()),
          BlocProvider<CategoryFilterBloc>(create: (context) => CategoryFilterBloc()),
          BlocProvider<WinesBloc>(create: (context) => WinesBloc()),
          BlocProvider<LikeBloc>(create: (context) => LikeBloc()),
          BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
          BlocProvider<FavsBloc>(create: (context) => FavsBloc()),
          BlocProvider<PromoCodeBloc>(create: (context) => PromoCodeBloc()),
          BlocProvider<NetworkBloc>(create: (context) => NetworkBloc()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme().themeData,
          routes: {
            // '/': (context) => const SplashScreen(),
            '/': (context) => const NetworkStatusScreen(),
            // '/': (context) => OrderConfirmationScreen(),
            '/cart_page': (context) => const ShoppingCartScreen(),
            '/home': (context) => const Home(),
            // 'product_page': (context) => const ProductPage(),
            // 'cart_page': (context) => const CartPage(),
            //'order_page': (context) => const OrderPage(),
            '/order_management_page': (context) => const OrderManagementPage(),
            '/category': (context) => const CategoryScreen(),
          },
        ),
      ),
    );
  }
}

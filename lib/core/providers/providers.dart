import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/network/bloc/network_bloc.dart';
import 'package:vintiora/core/theme/bloc/theme_bloc.dart';
import 'package:vintiora/features/cart/presentation/bloc/cart/cart_bloc.dart';
import 'package:vintiora/features/cart/presentation/bloc/promo_code/promo_code_bloc.dart';
import 'package:vintiora/features/home/presentation/bloc/carousel/carousel_bloc.dart';
import 'package:vintiora/features/main/presentation/bloc/navigation/bottom_navigation_bloc.dart';
import 'package:vintiora/features/order/presentation/bloc/order/order_bloc.dart';
import 'package:vintiora/features/order/presentation/bloc/shipment/shipment_bloc.dart';
import 'package:vintiora/features/order/presentation/bloc/shipping_address/shipping_address_bloc.dart';
import 'package:vintiora/features/product/presentation/bloc/category_filter/category_filter_bloc.dart';
import 'package:vintiora/features/product/presentation/bloc/category_list/wines_bloc.dart';
import 'package:vintiora/features/product/presentation/bloc/favorite/favs_bloc.dart';
import 'package:vintiora/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:vintiora/features/user/presentation/bloc/profile/profile_bloc.dart';

class Providers {
  static List<BlocProvider> get blocProviders {
    InternetConnectionChecker internetConnectionChecker = InternetConnectionChecker();

    return [
      BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
      BlocProvider<NetworkBloc>(create: (context) => NetworkBloc(internetConnectionChecker)),
      BlocProvider<NavigationBloc>(create: (context) => NavigationBloc()),
      BlocProvider<ProductBloc>(create: (context) => ProductBloc()),
      BlocProvider<CartBloc>(create: (context) => CartBloc()),
      BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
      BlocProvider<ShippingAddressBloc>(create: (context) => ShippingAddressBloc()),
      BlocProvider<ShipmentBloc>(create: (context) => ShipmentBloc()),
      BlocProvider<CarouselBloc>(create: (context) => CarouselBloc()),
      BlocProvider<CategoryFilterBloc>(create: (context) => CategoryFilterBloc()),
      BlocProvider<WinesBloc>(create: (context) => WinesBloc()),
      // BlocProvider<LikeBloc>(create: (context) => LikeBloc()),
      BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
      BlocProvider<FavsBloc>(create: (context) => FavsBloc()),
      BlocProvider<PromoCodeBloc>(create: (context) => PromoCodeBloc()),
    ];
  }
}

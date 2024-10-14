import 'package:flutter_bloc/flutter_bloc.dart';

import 'carousel/carousel_bloc.dart';
import 'cart/cart_bloc.dart';
import 'navigation/bottom_navigation_bloc.dart';
import 'network/network_bloc.dart';
import 'order/order_bloc.dart';
import 'product/category_filter/category_filter_bloc.dart';
import 'product/category_list/wines_bloc.dart';
import 'product/favorite/favs/favs_bloc.dart';
import 'product/favorite/like/like_bloc.dart';
import 'product/product_bloc.dart';
import 'profile/profile_bloc.dart';
import 'promo_code/promo_code_bloc.dart';
import 'shipment/shipment_bloc.dart';
import 'shipping_address/shipping_address_bloc.dart';
import 'theme/theme_cubit.dart';

class Providers {
  static List<BlocProvider> get blocProviders {
    return [
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
      BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
    ];
  }
}
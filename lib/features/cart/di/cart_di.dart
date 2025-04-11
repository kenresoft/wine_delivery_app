import 'package:vintiora/core/di/di_setup.dart';
import 'package:vintiora/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:vintiora/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:vintiora/features/cart/domain/repositories/cart_repository.dart';
import 'package:vintiora/features/cart/domain/usecases/add_to_cart.dart';
import 'package:vintiora/features/cart/domain/usecases/apply_coupon.dart';
import 'package:vintiora/features/cart/domain/usecases/decrement_cart_item.dart';
import 'package:vintiora/features/cart/domain/usecases/get_cart.dart';
import 'package:vintiora/features/cart/domain/usecases/increment_cart_item.dart';
import 'package:vintiora/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:vintiora/features/cart/domain/usecases/remove_coupon.dart';
import 'package:vintiora/features/cart/presentation/bloc/cart/cart_bloc.dart';

class CartDI {
  static dependencies() {
    // BLoC
    getIt.registerFactory(
      () => CartBloc(
        getCart: getIt(),
        addToCart: getIt(),
        incrementCartItem: getIt(),
        decrementCartItem: getIt(),
        removeCartItem: getIt(),
        applyCoupon: getIt(),
        removeCoupon: getIt(),
      ),
    );

    // Use cases
    getIt.registerLazySingleton(() => GetCart(getIt()));
    getIt.registerLazySingleton(() => AddToCart(getIt()));
    getIt.registerLazySingleton(() => IncrementCartItem(getIt()));
    getIt.registerLazySingleton(() => DecrementCartItem(getIt()));
    getIt.registerLazySingleton(() => RemoveCartItem(getIt()));
    getIt.registerLazySingleton(() => ApplyCoupon(getIt()));
    getIt.registerLazySingleton(() => RemoveCoupon(getIt()));

    // Repository
    getIt.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(
        remoteDataSource: getIt(),
        connectionChecker: getIt(),
      ),
    );

    // Data sources
    getIt.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(apiService: getIt()),
    );
  }
}

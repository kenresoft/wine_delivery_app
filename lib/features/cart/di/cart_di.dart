import 'package:vintiora/core/di/di_setup.dart';
import 'package:vintiora/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:vintiora/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:vintiora/features/cart/domain/repositories/cart_repository.dart';

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

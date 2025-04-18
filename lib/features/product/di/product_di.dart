import 'package:vintiora/core/di/di_setup.dart';
import 'package:vintiora/features/product/data/datasources/product_remote_data_source.dart';
import 'package:vintiora/features/product/data/repositories/product_repository_impl.dart';
import 'package:vintiora/features/product/domain/repositories/product_repository.dart';
import 'package:vintiora/features/product/domain/usecases/get_all_products.dart';
import 'package:vintiora/features/product/domain/usecases/get_new_arrivals.dart';
import 'package:vintiora/features/product/domain/usecases/get_popular_products.dart';
import 'package:vintiora/features/product/domain/usecases/get_product_by_id.dart';
import 'package:vintiora/features/product/domain/usecases/get_product_with_pricing.dart';
import 'package:vintiora/features/product/domain/usecases/get_products_by_ids.dart';
import 'package:vintiora/features/product/presentation/bloc/product/product_bloc.dart';

class ProductDI {
  static dependencies() {
    // DataSource
    getIt.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(apiService: getIt()));

    // Repository
    getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(
          remoteDataSource: getIt(),
          connectionChecker: getIt(),
        ));

    // Use Cases
    getIt.registerLazySingleton(() => GetAllProducts(getIt()));
    getIt.registerLazySingleton(() => GetProductById(getIt()));
    getIt.registerLazySingleton(() => GetProductsByIds(getIt()));
    getIt.registerLazySingleton(() => GetNewArrivals(getIt()));
    getIt.registerLazySingleton(() => GetPopularProducts(getIt()));
    getIt.registerLazySingleton(() => GetProductWithPricing(getIt<ProductRepository>()));

    // Bloc
    getIt.registerFactory(() => ProductBloc(
          getAllProducts: getIt(),
          getProductById: getIt(),
          getProductsByIds: getIt(),
          getNewArrivals: getIt(),
          getPopularProducts: getIt(),
          getProductWithPricing: getIt<GetProductWithPricing>(),
        ));
  }
}

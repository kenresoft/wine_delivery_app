import 'package:get_it/get_it.dart';
import 'package:vintiora/core/di/core_di.dart';
import 'package:vintiora/features/auth/di/auth_di.dart';
import 'package:vintiora/features/flash_sale/data/datasources/flash_sale_remote_data_source.dart';
import 'package:vintiora/features/flash_sale/data/repositories/flash_sale_repository_impl.dart';
import 'package:vintiora/features/flash_sale/domain/repositories/flash_sale_repository.dart';
import 'package:vintiora/features/flash_sale/presentation/blocs/active_flash_sales/active_flash_sales_bloc.dart';
import 'package:vintiora/features/flash_sale/presentation/blocs/flash_sale_details/flash_sale_details_bloc.dart';
import 'package:vintiora/features/flash_sale/presentation/blocs/flash_sale_products/flash_sale_products_bloc.dart';
import 'package:vintiora/features/main/presentation/bloc/navigation/bottom_navigation_bloc.dart';
import 'package:vintiora/features/product/di/product_di.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  CoreDI.dependencies();
  AuthDI.dependencies();
  ProductDI.dependencies();

  // Feature: Flash Sale
  getIt.registerLazySingleton<FlashSaleRemoteDataSource>(() => FlashSaleRemoteDataSourceImpl(apiService: getIt()));
  getIt.registerLazySingleton<FlashSaleRepository>(() => FlashSaleRepositoryImpl(remoteDataSource: getIt()));

  // Bloc
  getIt.registerFactory(() => ActiveFlashSalesBloc(repository: getIt()));
  getIt.registerFactory(() => FlashSaleDetailsBloc(repository: getIt()));
  getIt.registerFactory(() => FlashSaleProductsBloc(repository: getIt()));
}

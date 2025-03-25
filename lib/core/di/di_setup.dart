import 'package:get_it/get_it.dart';
import 'package:vintiora/core/cache/cache_service.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/api_service_impl.dart';
import 'package:vintiora/core/network/client/dio_network_client.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vintiora/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vintiora/features/auth/data/datasources/token_refresher.dart';
import 'package:vintiora/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vintiora/features/auth/domain/repositories/auth_repository.dart';
import 'package:vintiora/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/login_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/logout_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/register_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:vintiora/features/flash_sale/data/datasources/flash_sale_remote_data_source.dart';
import 'package:vintiora/features/flash_sale/data/repositories/flash_sale_repository_impl.dart';
import 'package:vintiora/features/flash_sale/domain/repositories/flash_sale_repository.dart';
import 'package:vintiora/features/flash_sale/presentation/blocs/active_flash_sales/active_flash_sales_bloc.dart';
import 'package:vintiora/features/flash_sale/presentation/blocs/flash_sale_details/flash_sale_details_bloc.dart';
import 'package:vintiora/features/flash_sale/presentation/blocs/flash_sale_products/flash_sale_products_bloc.dart';
import 'package:vintiora/features/product/data/datasources/product_remote_data_source.dart';
import 'package:vintiora/features/product/data/repositories/product_repository_impl.dart';
import 'package:vintiora/features/product/domain/repositories/product_repository.dart';
import 'package:vintiora/features/product/domain/usecases/get_all_products.dart';
import 'package:vintiora/features/product/domain/usecases/get_product_by_id.dart';
import 'package:vintiora/features/product/domain/usecases/get_products_by_ids.dart';
import 'package:vintiora/features/product/presentation/bloc/product/product_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  /// Core Dependencies
  getIt.registerLazySingleton<CacheService>(() => CacheServiceImpl());
  getIt.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());
  getIt.registerLazySingleton<INetworkClient>(() => DioNetworkClient(
        authDataSource: getIt<AuthLocalDataSource>(),
        cacheService: getIt<CacheService>(),
      ));
  getIt.registerLazySingleton<TokenRefresher>(() => TokenRefresher(
        networkClient: getIt<INetworkClient>(),
        localDataSource: getIt<AuthLocalDataSource>(),
      ));

  getIt.registerLazySingleton<IApiService>(() => ApiService(
        networkClient: getIt<INetworkClient>(),
        localDataSource: getIt<AuthLocalDataSource>(),
        tokenRefresher: getIt<TokenRefresher>(),
      ));

  // Feature: Auth
  // DataSource
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        apiService: getIt<IApiService>(),
      ));

  // Auth Repository
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
        localDataSource: getIt<AuthLocalDataSource>(),
      ));

  // Auth Use Cases
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<GetProfileUseCase>(() => GetProfileUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<CheckAuthUseCase>(() => CheckAuthUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<RefreshTokenUseCase>(() => RefreshTokenUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt<AuthRepository>()));

  // Feature: Product

  getIt.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(apiService: getIt()));
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(remoteDataSource: getIt()));

  // Bloc
  getIt.registerFactory(
    () => ProductBloc(
      getAllProducts: getIt(),
      getProductById: getIt(),
      getProductsByIds: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetAllProducts(getIt()));
  getIt.registerLazySingleton(() => GetProductById(getIt()));
  getIt.registerLazySingleton(() => GetProductsByIds(getIt()));

  // Feature: Flash Sale
  getIt.registerLazySingleton<FlashSaleRemoteDataSource>(() => FlashSaleRemoteDataSourceImpl(apiService: getIt()));
  getIt.registerLazySingleton<FlashSaleRepository>(() => FlashSaleRepositoryImpl(remoteDataSource: getIt()));

  // Bloc
  getIt.registerFactory(() => ActiveFlashSalesBloc(repository: getIt()));
  getIt.registerFactory(() => FlashSaleDetailsBloc(repository: getIt()));
  getIt.registerFactory(() => FlashSaleProductsBloc(repository: getIt()));
}

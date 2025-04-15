import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/core/cache/cache_service.dart';
import 'package:vintiora/core/di/di_setup.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/api_service_impl.dart';
import 'package:vintiora/core/network/client/dio_network_client.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vintiora/features/main/presentation/bloc/navigation/bottom_navigation_bloc.dart';

class CoreDI {
  static dependencies() {
    getIt.registerLazySingleton(() => InternetConnectionChecker());

    getIt.registerLazySingleton<CacheService>(() => CacheServiceImpl());
    getIt.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());

    getIt.registerLazySingleton<INetworkClient>(() => DioNetworkClient(
          authDataSource: getIt(),
          cacheService: getIt(),
        ));

    getIt.registerLazySingleton<IApiService>(() => ApiService(
          networkClient: getIt(),
          localDataSource: getIt(),
        ));

    getIt.registerLazySingleton(() => NavigationBloc());
  }
}

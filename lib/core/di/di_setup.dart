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

final getIt = GetIt.instance;

void setupDependencies() {
  // Core Dependencies
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

  // Feature: Auth DataSource
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        apiService: getIt<IApiService>(),
      ));

  // Feature: Auth Repository
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
        localDataSource: getIt<AuthLocalDataSource>(),
      ));

  // Feature: Auth Use Cases
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<GetProfileUseCase>(() => GetProfileUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<CheckAuthUseCase>(() => CheckAuthUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<RefreshTokenUseCase>(() => RefreshTokenUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt<AuthRepository>()));

  // Feature:
}

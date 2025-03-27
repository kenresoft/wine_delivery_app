import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/di/di_setup.dart';
import 'package:vintiora/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vintiora/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vintiora/features/auth/domain/repositories/auth_repository.dart';
import 'package:vintiora/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/login_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/logout_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/register_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:vintiora/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:vintiora/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:vintiora/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:vintiora/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:vintiora/features/auth/presentation/bloc/verify_otp/verify_otp_bloc.dart';

class AuthDI {
  static dependencies() {
    // DataSource
    getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
          apiService: getIt(),
        ));

    // Repository
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
          remoteDataSource: getIt(),
          localDataSource: getIt(),
        ));

    // Use Cases
    getIt.registerLazySingleton(() => LoginUseCase(getIt()));
    getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
    getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt()));
    getIt.registerLazySingleton(() => GetProfileUseCase(getIt()));
    getIt.registerLazySingleton(() => CheckAuthUseCase(getIt()));
    getIt.registerLazySingleton(() => RefreshTokenUseCase(getIt()));
    getIt.registerLazySingleton(() => LogoutUseCase(getIt()));

    // Blocs
    getIt.registerFactory(() => AuthBloc(checkAuthUseCase: getIt(), logoutUseCase: getIt()));
    getIt.registerFactory(() => RegisterBloc(registerUseCase: getIt()));
    getIt.registerFactory(() => LoginBloc(loginUseCase: getIt()));
    getIt.registerFactory(() => VerifyOtpBloc(verifyOtpUseCase: getIt()));
    getIt.registerFactory(() => ProfileBloc(getProfileUseCase: getIt()));
  }

  // Providers
  static List<BlocProvider> providers() {
    return [
      BlocProvider<AuthBloc>(create: (context) => getIt()),
      BlocProvider<RegisterBloc>(create: (context) => getIt()),
      BlocProvider<LoginBloc>(create: (context) => getIt()),
      BlocProvider<VerifyOtpBloc>(create: (context) => getIt()),
      BlocProvider<ProfileBloc>(create: (context) => getIt()),
    ];
  }
}

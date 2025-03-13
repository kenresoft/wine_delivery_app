// di.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/network/dio_client.dart';
import 'package:vintiora/core/providers/providers.dart';

import 'features/auth/data/datasources/auth_local_data_source.dart';
// Data layer
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
// Domain layer
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_auth_usecase.dart';
import 'features/auth/domain/usecases/get_profile_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/refresh_token_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
// Presentation layer - Blocs
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/auth/presentation/bloc/login/login_bloc.dart';
import 'features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'features/auth/presentation/bloc/register/register_bloc.dart';
import 'features/auth/presentation/bloc/verify_otp/verify_otp_bloc.dart';

class DependencyInjector extends StatelessWidget {
  final Widget child;
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final GetProfileUseCase getProfileUseCase;
  final CheckAuthUseCase checkAuthUseCase;
  final RefreshTokenUseCase refreshTokenUseCase;
  final LogoutUseCase logoutUseCase;

  const DependencyInjector._({
    required this.child,
    required this.registerUseCase,
    required this.loginUseCase,
    required this.verifyOtpUseCase,
    required this.getProfileUseCase,
    required this.checkAuthUseCase,
    required this.refreshTokenUseCase,
    required this.logoutUseCase,
  });

  static Future<DependencyInjector> create({required Widget child}) async {
    // Create Data Sources using Dio
    final authLocalDataSource = AuthLocalDataSourceImpl();
    final dioClient = DioClient(authLocalDataSource);
    final authRemoteDataSource = AuthRemoteDataSourceImpl(dioClient: dioClient);

    // Create Repository
    final AuthRepository authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      localDataSource: authLocalDataSource,
    );

    // Create Use Cases
    final registerUseCase = RegisterUseCase(authRepository);
    final loginUseCase = LoginUseCase(authRepository);
    final verifyOtpUseCase = VerifyOtpUseCase(authRepository);
    final getProfileUseCase = GetProfileUseCase(authRepository);
    final checkAuthUseCase = CheckAuthUseCase(authRepository);
    final refreshTokenUseCase = RefreshTokenUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);

    return DependencyInjector._(
      registerUseCase: registerUseCase,
      loginUseCase: loginUseCase,
      verifyOtpUseCase: verifyOtpUseCase,
      getProfileUseCase: getProfileUseCase,
      checkAuthUseCase: checkAuthUseCase,
      refreshTokenUseCase: refreshTokenUseCase,
      logoutUseCase: logoutUseCase,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RegisterUseCase>.value(value: registerUseCase),
        RepositoryProvider<LoginUseCase>.value(value: loginUseCase),
        RepositoryProvider<VerifyOtpUseCase>.value(value: verifyOtpUseCase),
        RepositoryProvider<GetProfileUseCase>.value(value: getProfileUseCase),
        RepositoryProvider<CheckAuthUseCase>.value(value: checkAuthUseCase),
        RepositoryProvider<RefreshTokenUseCase>.value(value: refreshTokenUseCase),
        RepositoryProvider<LogoutUseCase>.value(value: logoutUseCase),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(
              checkAuthUseCase: checkAuthUseCase,
              logoutUseCase: logoutUseCase,
            ),
          ),
          BlocProvider<RegisterBloc>(
            create: (_) => RegisterBloc(registerUseCase: registerUseCase),
          ),
          BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(loginUseCase: loginUseCase),
          ),
          BlocProvider<VerifyOtpBloc>(
            create: (_) => VerifyOtpBloc(verifyOtpUseCase: verifyOtpUseCase),
          ),
          BlocProvider<ProfileBloc>(
            create: (_) => ProfileBloc(getProfileUseCase: getProfileUseCase),
          ),
          ...Providers.blocProviders
        ],
        child: child,
      ),
    );
  }
}

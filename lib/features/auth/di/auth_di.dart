// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vintiora/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/logout_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/register_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:vintiora/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:vintiora/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:vintiora/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:vintiora/features/auth/presentation/bloc/verify_otp/verify_otp_bloc.dart';

import '../data/datasources/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../presentation/bloc/auth/auth_bloc.dart';

class AuthDI {
  static List<RepositoryProvider> repositories() => [
        RepositoryProvider<AuthLocalDataSource>(
          create: (context) => AuthLocalDataSourceImpl(),
        ),
        RepositoryProvider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSourceImpl(
            apiService: context.read<IApiService>(),
          ),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
            localDataSource: context.read<AuthLocalDataSource>(),
          ),
        ),
      ];

  static List<RepositoryProvider> useCases() => [
        RepositoryProvider<LoginUseCase>(
          create: (context) => LoginUseCase(context.read<AuthRepository>()),
        ),
        RepositoryProvider<RegisterUseCase>(
          create: (context) => RegisterUseCase(context.read<AuthRepository>()),
        ),
        RepositoryProvider<VerifyOtpUseCase>(
          create: (context) => VerifyOtpUseCase(context.read<AuthRepository>()),
        ),
        RepositoryProvider<GetProfileUseCase>(
          create: (context) => GetProfileUseCase(context.read<AuthRepository>()),
        ),
        RepositoryProvider<CheckAuthUseCase>(
          create: (context) => CheckAuthUseCase(context.read<AuthRepository>()),
        ),
        RepositoryProvider<RefreshTokenUseCase>(
          create: (context) => RefreshTokenUseCase(context.read<AuthRepository>()),
        ),
        RepositoryProvider<LogoutUseCase>(
          create: (context) => LogoutUseCase(context.read<AuthRepository>()),
        ),
      ];

  static List<BlocProvider> blocs() => [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            checkAuthUseCase: context.read<CheckAuthUseCase>(),
            logoutUseCase: context.read<LogoutUseCase>(),
          ),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(registerUseCase: context.read<RegisterUseCase>()),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(loginUseCase: context.read<LoginUseCase>()),
        ),
        BlocProvider<VerifyOtpBloc>(
          create: (context) => VerifyOtpBloc(verifyOtpUseCase: context.read<VerifyOtpUseCase>()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(getProfileUseCase: context.read<GetProfileUseCase>()),
        ),
      ];
}

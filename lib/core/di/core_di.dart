import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vintiora/core/cache/cache_service.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vintiora/features/auth/domain/repositories/auth_repository.dart';

class CoreDI {
  static List<RepositoryProvider> providers() {
    return [
      RepositoryProvider<AuthLocalDataSource>(create: (_) => GetIt.I<AuthLocalDataSource>()),
      RepositoryProvider<CacheService>(create: (_) => GetIt.I<CacheService>()),
      RepositoryProvider<INetworkClient>(create: (_) => GetIt.I<INetworkClient>()),
      RepositoryProvider<IApiService>(create: (_) => GetIt.I<IApiService>()),
      RepositoryProvider<AuthRepository>(create: (_) => GetIt.I<AuthRepository>()),
    ];
  }
}

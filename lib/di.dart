import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/cache_service.dart';
import 'package:vintiora/core/network/dio_client.dart';
import 'package:vintiora/core/providers/providers.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';

import 'core/di/core_di.dart';
import 'features/auth/di/auth_di.dart';
// import 'features/cart/di/cart_di.dart'; // Add other features

class DependencyInjector extends StatelessWidget {
  final Widget child;
  final DioClient dioClient;
  final ApiService apiService;

  const DependencyInjector._({
    required this.child,
    required this.dioClient,
    required this.apiService,
  });

  static Future<DependencyInjector> create({required Widget child}) async {
    // Initialize core dependencies
    final authLocalDataSource = AuthLocalDataSourceImpl();
    final cacheService = CacheServiceImpl();
    final dioClient = DioClient(cacheService, authLocalDataSource);
    final apiService = ApiService(dioClient: dioClient);

    return DependencyInjector._(
      dioClient: dioClient,
      apiService: apiService,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Core dependencies
        ...CoreDI.providers(/*dioClient, */apiService),
        // Auth
        ...AuthDI.repositories(),
        ...AuthDI.useCases(),
        // Cart
        // ...CartDI.repositories(context),
        // ...CartDI.useCases(),
        // Add other features...
      ],
      child: MultiBlocProvider(
        providers: [
          // Auth
          ...AuthDI.blocs(),
          // Cart
          // ...CartDI.blocs(),
          // Add other features...
          ...Providers.blocProviders // Remove
        ],
        child: child,
      ),
    );
  }
}

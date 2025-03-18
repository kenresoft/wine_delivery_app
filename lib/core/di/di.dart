import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/di/core_di.dart';
import 'package:vintiora/core/providers/providers.dart';
import 'package:vintiora/features/auth/di/auth_di.dart';

class DependencyInjector extends StatelessWidget {
  final Widget child;

  const DependencyInjector({super.key, required this.child});

  static Future<Widget> create({required Widget child}) async {
    return DependencyInjector(child: child);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        ...CoreDI.providers(),
        // Feature: Auth
        ...AuthDI.repositories(),
        ...AuthDI.useCases(),
        // Feature:
      ],
      child: MultiBlocProvider(
        providers: [
          // Feature-specific blocs
          ...AuthDI.blocs(),
          // Additional bloc providers
          ...Providers.blocProviders,
        ],
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        ...AuthDI.providers(),
        ...Providers.blocProviders,
      ],
      child: child,
    );
  }
}

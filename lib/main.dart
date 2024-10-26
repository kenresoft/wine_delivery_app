import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'bloc/providers.dart';
import 'utils/helpers.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Forward Flutter framework errors to `runZonedGuarded`
    FlutterError.onError = (FlutterErrorDetails details) {
      logger.e("Flutter Framework Error: ${details.exceptionAsString()}", stackTrace: details.stack);
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    };

    try {
      await loadConfig(
        done: (error) {
          if (error != null) {
            throw error;
          } else {
            logger.d('No error during initialization');
            runApp(
              MultiBlocProvider(
                providers: Providers.blocProviders,
                child: const MyApp(),
              ),
            );
          }
        },
      );
    } catch (error, stackTrace) {
      logger.e("Error during initialization: $error", stackTrace: stackTrace);
      runApp(
        MultiBlocProvider(
          providers: Providers.blocProviders,
          child: MyApp(initialError: error),
        ),
      );
    }
  }, (error, stack) {
    logger.e("Unhandled asynchronous error: $error", stackTrace: stack);
  });
}



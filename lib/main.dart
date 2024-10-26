import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'bloc/providers.dart';
import 'utils/helpers.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = _handleFlutterError;

    try {
      await _initializeApp();
    } catch (error, stackTrace) {
      logger.e("Initialization Error: $error", stackTrace: stackTrace);
      _runAppWithError(error);
    }
  }, (error, stackTrace) {
    logger.e("Unhandled asynchronous error: $error", stackTrace: stackTrace);
  });
}

/// Flutter framework error handling
void _handleFlutterError(FlutterErrorDetails details) {
  logger.e("Flutter Framework Error: ${details.exceptionAsString()}", stackTrace: details.stack);
  Zone.current.handleUncaughtError(details.exception, details.stack!);
}

/// Initializes the app configuration and runs the app
Future<void> _initializeApp() async {
  await loadConfig(
    done: (error) {
      if (error != null) {
        throw error;
      }
      logger.d('App initialized successfully with no errors');
      _runApp();
    },
  );
}

/// Runs the app without initialization errors
void _runApp() {
  runApp(
    MultiBlocProvider(
      providers: Providers.blocProviders,
      child: const MyApp(),
    ),
  );
}

/// Runs the app with an initialization error state
void _runAppWithError(Object error) {
  runApp(
    MultiBlocProvider(
      providers: Providers.blocProviders,
      child: MyApp(initializationError: error),
    ),
  );
}

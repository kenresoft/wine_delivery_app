import 'dart:async';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/config/app_config.dart';
import 'package:vintiora/core/providers/providers.dart';
import 'package:vintiora/core/storage/preferences.dart';

import 'app.dart';
import 'core/utils/helpers.dart';
import 'di.dart';

Future<void> main() async {
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
  Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.empty);
}

/// Initializes the app configuration and runs the app
Future<void> _initializeApp() async {
  await Config.load(
    done: (error) async {
      if (error != null) {
        logger.e('Failed to load app configuration: $error');
        isWindows || isWeb ? null : throw error;
      }
      logger.d('App initialized successfully with no errors');
      // _runApp();
      final injector = await DependencyInjector.create(
        child: const MyApp(),
      );
      logger.w(storage);
      runApp(injector);
    },
  );
}

/// Runs the app without initialization errors
/*void _runApp() {
  logger.w(storage);

  runApp(
    MultiBlocProvider(
      providers: Providers.blocProviders,
      child: const MyApp(),
    ),
  );
}*/

/// Runs the app with an initialization error state
void _runAppWithError(Object error) {
  runApp(
    MultiBlocProvider(
      providers: Providers.blocProviders,
      child: MyApp(initializationError: error),
    ),
  );
}

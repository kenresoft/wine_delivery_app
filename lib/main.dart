import 'dart:async';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:vintiora/core/config/app_config.dart';
import 'package:vintiora/core/di/di.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/storage/preferences.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/core/utils/utils.dart';
import 'package:vintiora/shared/components/error_page.dart';

import 'app.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    ErrorWidget.builder = (FlutterErrorDetails details) {
      return MaterialApp(
        title: Constants.appName,
        navigatorKey: Nav.navigatorKey,
        navigatorObservers: [Nav.routeObserver, Nav.stateObserver],
        debugShowCheckedModeBanner: false,
        home: ErrorPage(
          errorType: ErrorType.initialization,
          message: details.toStringShort(),
          error: details.exception,
          stackTrace: details.stack,
          onRetry: () async {
            // Retry full app initialization by restarting
            await _runAppWithError(details.exception);
          },
        ),
      );
    };

    // Log framework errors
    FlutterError.onError = _handleFlutterError;

    try {
      await _initializeApp();
    } catch (error, stackTrace) {
      logger.e("Initialization Error: $error", stackTrace: stackTrace);
      await _runAppWithError(error);
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
    onComplete: (error) async {
      if (error != null) {
        logger.e('Failed to load app configuration: $error');
        isWindows || isWeb ? null : throw error;
      }
      logger.d('App initialized successfully with no errors');
      await _runApp();
    },
  );
}

/// Runs the app without initialization errors
Future<void> _runApp() async {
  final injector = await DependencyInjector.create(child: MyApp());
  logger.w(storage);
  runApp(injector);
}

/// Runs the app with an initialization error state
Future<void> _runAppWithError(Object error) async {
  final injector = await DependencyInjector.create(
    child: MyApp(initializationError: error),
  );
  runApp(injector);
}

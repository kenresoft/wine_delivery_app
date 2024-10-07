import 'dart:async';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wine_delivery_app/utils/environment_config.dart';
import 'package:wine_delivery_app/utils/utils.dart';

import 'app.dart';
import 'bloc/providers.dart';

void main() async {
  // Run the app in a guarded zone for uncaught errors
  runZonedGuarded(() async {
    // Ensure that the Flutter binding is initialized in the same zone as runApp
    WidgetsFlutterBinding.ensureInitialized();

    // Capture any Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      logger.e(
        "Flutter Error: ${details.exceptionAsString()}",
        stackTrace: details.stack,
      );
    };
    try {
      // Load configuration and services after binding initialization
      await SharedPreferencesService.init(
        enableCaching: true,
        cacheOptions: const SharedPreferencesWithCacheOptions()
      );
      await EnvironmentConfig.load(ConfigMode.dev);
      // Stripe.publishableKey = Constants.stripePublishableKey;

      // initialize hydrated bloc
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
      );

      logger.d('No error during initialization');
      runApp(
        MultiBlocProvider(
          providers: Providers.blocProviders,
          child: const MyApp(),
        ),
      );
    } catch (error) {
      // Handle any initialization errors
      logger.e("Error during initialization: $error");
      runApp(
        MultiBlocProvider(
          providers: Providers.blocProviders,
          child: MyApp(initialError: error),
        ),
      ); // Pass the error to MyApp
    }
  }, (error, stack) {
    // Handle uncaught errors
    logger.e("Unhandled error: $error", stackTrace: stack);
  });
}



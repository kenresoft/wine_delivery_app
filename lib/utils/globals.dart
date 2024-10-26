import 'dart:io';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'constants.dart';
import 'environment_config.dart';

final logger = Logger();

const int socketErrorCode = 888;

double? toDouble(dynamic value) {
  // logger.i(value.runtimeType);
  if (value == null) return null;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  return null; // Handle other unexpected types or nulls
}

void snackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message.toString()),
    backgroundColor: Theme.of(context).primaryColor,
    duration: Duration(seconds: 4),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> loadConfig({void Function(dynamic error)? done}) async {
  try {
    await SharedPreferencesService.init(
      enableCaching: true,
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    await EnvironmentConfig.load(ConfigMode.dev);
    Stripe.publishableKey = Constants.stripePublishableKey;

    // initialize hydrated bloc
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
    );

    // await _simulateError();

    done?.call(null);
  } catch (e) {
    logger.e('Error loading config: $e');
    done?.call(e);
  }
}

Future<void> _simulateError() async {
  final file = File('non_existent_file.txt');
  await file.readAsString();
}
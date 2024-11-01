import 'dart:io';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:os_detect/os_detect.dart' as os_detect;
import 'package:path_provider/path_provider.dart';
import 'package:wine_delivery_app/utils/helpers.dart';

import '../firebase_options.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';
import 'firebase_util.dart';
import 'notification_util.dart';

final logger = Logger();

const int socketErrorCode = 888;

double? toDouble(dynamic value) {
  // logger.i(value.runtimeType);
  if (value == null) return null;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  return null; // Handle other unexpected types or nulls
}

void snackBar(String message) {
  final context = Nav.navigatorKey.currentContext;
  if (context != null) {
    final snackBar = SnackBar(
      content: Text(message.toString()),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 4),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

Future<void> loadConfig({void Function(dynamic error)? done}) async {
  try {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
    );
    await SharedPreferencesService.init(
      enableCaching: true,
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    await EnvironmentConfig.load(ConfigMode.dev);
    Stripe.publishableKey = Constants.stripePublishableKey;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseUtil.configureFirebaseMessaging();
    await NotificationUtil.initNotification();

    bool isAuthenticated = await authRepository.checkAuthStatus();
    if (isAuthenticated) {
      await userRepository.initializeDeviceToken();
    }

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

var isWeb = os_detect.isBrowser;
var isAndroid = os_detect.isAndroid;
var isFuchsia = os_detect.isFuchsia;
var isIOS = os_detect.isIOS;
var isMacOS = os_detect.isMacOS;
var isWindows = os_detect.isWindows;
var isLinux = os_detect.isLinux;
var osVersion = os_detect.operatingSystemVersion;
var os = os_detect.operatingSystem;

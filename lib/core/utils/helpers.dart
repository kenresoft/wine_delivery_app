import 'package:flutter/material.dart';
import 'package:os_detect/os_detect.dart' as os_detect;

import '../router/nav.dart';

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
      duration: const Duration(seconds: 4),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
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

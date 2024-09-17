/*
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<void> logToDevice(String message) async {
  final logFilePath = await getLogFilePath();
  final file = File(logFilePath);
  await file.writeAsString(message, mode: FileMode.append);
}

Future<String> getLogFilePath() async {
  final appDirectory = await getApplicationDocumentsDirectory();
  final logFilePath = '${appDirectory.path}/my_app.log';
  return logFilePath;
}*/

import 'dart:io';

import 'package:path_provider/path_provider.dart' as path;
import 'package:permission_handler/permission_handler.dart';

Future<void> logToDevice(String message, [String? name]) async {
  final directory = await path.getDownloadsDirectory();
  final kDirectory = '${directory?.path}';

  final logFilePath = '$kDirectory/${name ?? 'my_app.log'}';
  final file = File(logFilePath);

  // Request permission if not already granted
  final status = await Permission.manageExternalStorage.request();
  // final status = await Permission.storage.request();
  if (!status.isGranted) {
    throw Exception('Storage permission denied');
  }

  await file.writeAsString(message, mode: FileMode.writeOnly);
}

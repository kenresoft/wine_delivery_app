import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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

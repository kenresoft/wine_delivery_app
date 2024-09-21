import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:wine_delivery_app/utils/internet_connection_checker.dart';

import '../utils/utils.dart';

class NetworkRepository {
  const NetworkRepository._();

  static const NetworkRepository _instance = NetworkRepository._();

  static NetworkRepository getInstance() => _instance;

  static final Connectivity _connectivity = Connectivity();
  static List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

  // Getter to expose the current connection status
  List<ConnectivityResult> get connectionStatus => _connectionStatus;

  /// Initialize and check the current connectivity status.
  Future<List<ConnectivityResult>> initConnectivity() async {
    late List<ConnectivityResult> result;

    // Handle platform-specific exceptions when checking connectivity
    try {
      result = await _connectivity.checkConnectivity(); // Get list of ConnectivityResult
    } on PlatformException catch (e) {
      logger.e('Couldn\'t check connectivity status: $e');
      rethrow;
    }

    _updateConnectionStatus(result);
    return result;
  }

  // Update the connection status and perform necessary actions
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    logger.w('Connectivity changed: $_connectionStatus');
  }

  /// Start listening for connectivity changes
  Stream<List<ConnectivityResult>> startListening() {
    return _connectivity.onConnectivityChanged.map((List<ConnectivityResult> result) {
      _updateConnectionStatus(result);
      return result;
    });
  }

  Future<bool> isConnected() async {
    final hasConnection = await internetConnectionChecker.hasInternetConnection(useCaching: false);
    return hasConnection.isConnected;
  }
}

final NetworkRepository networkRepository = NetworkRepository.getInstance();

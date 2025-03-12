import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';

class SocketRepository {
  SocketRepository._();

  static final SocketRepository _instance = SocketRepository._();

  static SocketRepository getInstance() => _instance;

  sio.Socket? socket;
  bool _isReconnecting = false;
  Duration _reconnectDelay = const Duration(seconds: 5); // Initial reconnect delay
  int _reconnectAttempts = 0; // Track reconnection attempts
  final _maxReconnectAttempts = 3; // Maximum reconnection attempts

  Future<void> connectSocket() async {
    try {
      final authToken = await AuthLocalDataSourceImpl().getAccessToken(); // Get auth token
      socket = sio.io(
        Constants.wsBaseUrl,
        sio.OptionBuilder().setTransports(
          ['websocket'],
        ).setExtraHeaders({
          'Authorization': 'Bearer $authToken',
        }).build(),
      );

      socket!.onConnect((_) {
        debugPrint('Connected to the order socket.');
        _isReconnecting = false; // Reset reconnection flag
        socket?.emit('sendMessage', 'Hi, Welcome!'); // (Optional)
      });

      socket!.on('orderUpdated', (data) {
        // Handle order update event
      });

      socket!.on('error', (error) {
        debugPrint('WebSocket Error: $error');
        // Implement more robust error handling (logging, notification)
        reconnect(); // Attempt reconnection
      });

      socket!.onDisconnect((_) {
        debugPrint('Disconnected from the order socket.');
        reconnect(); // Attempt reconnection
      });
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void disconnectSocket() {
    socket?.disconnect();
    _isReconnecting = false; // Reset reconnection flag
  }

  Future<void> reconnect() async {
    if (_isReconnecting || _reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('Reached maximum reconnection attempts.');
      return;
    }

    _isReconnecting = true;
    _reconnectAttempts++;

    await Future.delayed(_reconnectDelay);
    debugPrint('Reconnecting to socket...');
    await connectSocket(); // Retry connecting

    // Increase reconnect delay exponentially for subsequent attempts
    _reconnectDelay *= 2; // Double the delay
  }
}

SocketRepository socketRepository = SocketRepository.getInstance();

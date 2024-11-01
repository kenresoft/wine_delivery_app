import 'dart:developer' as dev;

import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_util.dart';

class FirebaseUtil {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> configureFirebaseMessaging() async {
    // Request permission for iOS
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      sound: true,
    );

    dev.log('Permission granted: ${settings.authorizationStatus}');

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      dev.log("Message received in foreground: ${message.notification?.title}");
      NotificationUtil.showNotification(message); // Show notification
      handleMessage(message); // Additional handling if required
    });

    // Handle background notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      dev.log("Message opened from background: ${message.notification?.title}");
      NotificationUtil.showNotification(message); // Show notification
      String? targetPage = message.data['navigateTo'];
      if (targetPage != null) {
        NotificationUtil.navigateToPage(targetPage); // Navigate based on payload
      }
    });

    // Handle background message
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    try {
      // Retry logic for getToken()
      await _firebaseMessaging.getToken().timeout(const Duration(seconds: 30)).then((token) {
        dev.log("FCM Token: $token");
      });
    } catch (e) {
      dev.log('Error fetching FCM token: $e');
      // Implement retry mechanism if needed
    }

    // Subscribe to a topic if needed
    _firebaseMessaging.subscribeToTopic('news');
  }

  // Handle background message processing
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // Handle background messages here.
    // notification()
    //     .showNotification(title: '${message.notification?.title}', body: '${message.notification?.body}');
    dev.log("Handling background message: ${message.notification?.title}");
    NotificationUtil.showNotification(message); // Show notification in background
  }

  static void handleMessage(RemoteMessage message) {
    dev.log("Handling message data: ${message.data}");
    // Further data handling logic as needed
  }
}

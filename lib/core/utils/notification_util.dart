import 'dart:developer' as dev;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vintiora/core/utils/constants.dart';

class NotificationUtil {
  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final WindowsInitializationSettings initializationSettingsWindows = WindowsInitializationSettings(
      appName: Constants.appName,
      appUserModelId: Constants.packageName,
      // Search online for your own unique GUID generators
      guid: 'd49b0314-ee7a-4626-bf79-97cdb8a991bb',
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      windows: initializationSettingsWindows,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        String? payload = notificationResponse.payload;
        if (payload != null) {
          navigateToPage(payload); // Navigate based on payload if the notification is tapped
        }
      },
    );
  }

  // Function to display notification when app is active
  static Future<void> showNotification(RemoteMessage message) async {
    final data = message.data;
    final payload = data['navigateTo']; // Custom payload for navigation if specified

    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel', 'Default Channel', // message.notification!.android!.channelId.toString()
      description: 'Channel for default notifications',
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
    );

    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id, channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      // sound: channel.sound
      //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
      //  icon: largeIconPath
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await notificationsPlugin.show(
      0,
      message.notification?.title ?? 'Default Title',
      message.notification?.body ?? 'Default Body',
      notificationDetails,
      payload: payload, // Attach payload for navigation
    );
  }

  // Function to navigate to a specific page based on payload
  static void navigateToPage(String page) {
    switch (page) {
      case 'home':
        dev.log("Navigating to Home Page");
        // Navigator logic for Home Page
        break;
      case 'cart':
        dev.log("Navigating to Cart Page");
        // Navigator logic for Cart Page
        break;
      default:
        dev.log("Unknown page: $page");
    }
  }
}

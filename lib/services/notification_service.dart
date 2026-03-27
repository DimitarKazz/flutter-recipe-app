import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

// Background message handler (мора да биде top-level функција)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📩 Background message: ${message.notification?.title}');
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('📱 Notification permission: ${settings.authorizationStatus}');

    // Get FCM token
    String? token = await _messaging.getToken();
    print('📲 FCM Token: $token');

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listen to background messages
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Schedule daily notification (after 10 seconds for testing)
    await scheduleDailyNotification();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('📩 Foreground message: ${message.notification?.title}');
    _showLocalNotification(
      message.notification?.title ?? 'New Recipe',
      message.notification?.body ?? 'Check out today\'s recipe!',
    );
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print('📩 Background message opened: ${message.notification?.title}');
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notification tapped: ${response.payload}');
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'recipe_channel',
      'Recipe Notifications',
      channelDescription: 'Daily recipe reminders',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      Random().nextInt(1000),
      title,
      body,
      details,
      payload: 'random_recipe',
    );
  }

  Future<void> scheduleDailyNotification() async {
    // За тестирање - нотификација после 10 секунди
    await Future.delayed(const Duration(seconds: 10));

    _showLocalNotification(
      '🍽️ Recipe of the Day!',
      'Discover a new delicious recipe today! Tap to view.',
    );

    print('⏰ Daily notification scheduled');
  }

  Future<void> sendTestNotification() async {
    await _showLocalNotification(
      '🧪 Test Notification',
      'This is a test notification from Recipe App!',
    );
  }
}

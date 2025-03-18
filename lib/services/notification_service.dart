import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse response) async {}

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: darwinInitializationSettings);

    //init pluginu z ustawieniami
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotification,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification);

    //zgoda na powiadomienia
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNotification(
      String title, String body, DateTime time) async {
    const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails("channel_Id", "channel_Name",
            importance: Importance.defaultImportance, priority: Priority.high),
        iOS: DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0, title, body, TZDateTime.from(time, local), notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }
}

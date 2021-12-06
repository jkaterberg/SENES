import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  late FlutterLocalNotificationsPlugin notification;
  BuildContext context;

  NotificationHelper(this.context) {
    tz.initializeTimeZones();
    initNotification();
  }

  initNotification() {
    notification = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    notification.initialize(initializationSettings);
  }

  Future scheduleNotification(
      String title, String message, DateTime time) async {
    /// Schedule a notification to be sent in the future
    var android = const AndroidNotificationDetails("channelId", "channelName",
        priority: Priority.defaultPriority,
        importance: Importance.defaultImportance);

    var platformDetails = NotificationDetails(android: android);

    await notification.zonedSchedule(101, title, message,
        tz.TZDateTime.from(time, tz.local), platformDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final NotificationApi _instance = NotificationApi._internal();
  factory NotificationApi() => _instance;
  final _notifications = FlutterLocalNotificationsPlugin();
  NotificationApi._internal() {
    var initializationSettingsAndroid = const AndroidInitializationSettings(
        'logo'); // <- default icon name is @mipmap/ic_launcher
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      // print('onDidReceiveLocalNotification: $id, $title, $body, $payload');
    });
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    _notifications.initialize(initializationSettings,
        onSelectNotification: ((payload) {}));
  }

  Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          importance: Importance.max,
          priority: Priority.max,
          // ticker: 'ticker',
        ),
        iOS: IOSNotificationDetails());
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    _notifications.show(id, title, body, await _notificationDetails());
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:taskflow/src/data/model/notification/notification_data.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final logger = Logger();

  static Future<void> initialize() async {
    final logger = Logger();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotificationOfServer(message);
      logger.i('📩 Có thông báo: ${message.notification?.title}');
    });
  }

  Future<void> init() async {
    String? token = await _messaging.getToken();
    logger.i(token);
    // trong trường hợp token bị thay đổi
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      logger.i(newToken);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showNotificationOfServer(message);
      logger.i('📩 Có thông báo: ${message.notification?.title}');

      // Hiển thị dialog hoặc local notification
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.i('📲 Người dùng đã mở thông báo: ${message.notification?.title}');
    });
  }

  Future<void> showNotification(String title) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'File Downloads',
      channelDescription: 'Notification for successful file download',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: 'download',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      '$title has been downloaded successfully',
      platformChannelSpecifics,
    );
  }

  static Future<void> showNotificationOfServer(RemoteMessage message) async {
    final logger = Logger();
    NotificationData notificationData = NotificationData.fromJson(message.data);
    logger.i(notificationData.typeContent);
    final content = notificationData.typeContent ?? '';
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'task_channel',
      'Task',
      channelDescription: 'Notification for successful file download',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: 'download',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    if (notificationData.type == 'TASK') {
      if (content.contains("REMOVE_ASSIGN")) {
        await flutterLocalNotificationsPlugin.show(
          notificationData.id!,
          '${'TASK'.tr()} ${notificationData.titleTask}',
          '${notificationData.senderName} ${'NotifiRemove'.tr()} ${notificationData.titleTask}',
          platformChannelSpecifics,
        );
      } else if (content.contains("NEW_ASSIGN")) {
        await flutterLocalNotificationsPlugin.show(
          notificationData.id!,
          '${'TASK'.tr()} ${notificationData.titleTask}',
          '${notificationData.senderName} ${'NotifiAddTask'.tr()} ${notificationData.titleTask}',
          platformChannelSpecifics,
        );
      }
    } else if (notificationData.type == 'SYSTEM') {
      if (content.contains("DUEAT")) {
        await flutterLocalNotificationsPlugin.show(
          notificationData.id!,
          '${'TASK'.tr()} ${notificationData.titleTask}',
          '${'NotifiDueAt'.tr()} ${notificationData.titleTask}',
          platformChannelSpecifics,
        );
      }
    } else if (notificationData.type == 'COMMENT') {
      await flutterLocalNotificationsPlugin.show(
        notificationData.id!,
        '${'TASK'.tr()} ${notificationData.titleTask}',
        '${notificationData.senderName} ${'NotifiComment'.tr()} ${notificationData.titleTask}',
        platformChannelSpecifics,
      );
    } else if (notificationData.type == 'CONTACT') {
      await flutterLocalNotificationsPlugin.show(
        notificationData.id!,
        'friendRequest'.tr(),
        '${notificationData.senderName} ${'NotifiRequest'.tr()}',
        platformChannelSpecifics,
      );
    }
  }
}

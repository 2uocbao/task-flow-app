import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/model/notification/notification_data.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_arguments.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final logger = Logger();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
    String? token = await _messaging.getToken();
    logger.i(token);
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      logger.i(newToken);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showNotificationOfServer(message);
      logger.i('📩 Có thông báo: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _onFirebaseTap(message);
      logger.i('📲 Người dùng đã mở thông báo: ${message.notification?.title}');
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onFirebaseTap(initialMessage);
    }
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    _handleNotificationClick(payload);
  }

  void _onFirebaseTap(RemoteMessage message) {
    final data = message.data;
    final payload = data['payload'] ?? '';
    _handleNotificationClick(payload);
  }

  void _handleNotificationClick(String? payload) {
    if (payload == null || payload.isEmpty) return;
    if (payload.startsWith("task:")) {
      final taskId = payload.replaceFirst("task:", "");
      NavigatorService.pushNamed(AppRoutes.taskDetailScreen,
          arguments: TaskDetailArguments(taskId: taskId));
    } else {
      NavigatorService.pushNamed(AppRoutes.homeScreen);
    }
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

  Future<void> showNotificationOfServer(RemoteMessage message) async {
    NotificationData notificationData = NotificationData.fromJson(message.data);
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'server_channel',
      'Server',
      channelDescription: 'Notification for server',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    int notifiId = int.parse(notificationData.id!);
<<<<<<< HEAD

    switch (notificationData.type) {
      case 'TASK':
        switch (notificationData.typeContent) {
          case 'REMOVE_ASSIGN':
            await flutterLocalNotificationsPlugin.show(
              notifiId,
              '${'TASK'.tr()}  ${notificationData.titleTask}',
              '${notificationData.senderName} ${'NotifiRemove'.tr()} ${notificationData.titleTask}',
              platformChannelSpecifics,
            );
            break;
          case 'NEW_ASSIGN':
            await flutterLocalNotificationsPlugin.show(
              notifiId,
              '${'TASK'.tr()}  ${notificationData.titleTask}',
              '${notificationData.senderName} ${'NotifiAddTask'.tr()} ${notificationData.titleTask}',
              platformChannelSpecifics,
              payload: 'task:${notificationData.contentId}',
            );
            break;
          case 'DUEAT':
            await flutterLocalNotificationsPlugin.show(
              notifiId,
              '${'TASK'.tr()} ${notificationData.titleTask}',
              '${'NotifiDueAt'.tr()} ${notificationData.titleTask}',
              platformChannelSpecifics,
              payload: 'task:${notificationData.contentId}',
            );
            break;
          case 'REPORT':
            await flutterLocalNotificationsPlugin.show(
              notifiId,
              '${'TASK'.tr()}  ${notificationData.titleTask}',
              '${notificationData.senderName} ${'new_report'.tr()} ${notificationData.titleTask}',
              platformChannelSpecifics,
              payload: 'task:${notificationData.contentId}',
            );
            break;
          default:
            await flutterLocalNotificationsPlugin.show(
              notifiId,
              'notifi_new'.tr(),
              'notifi_detail'.tr(),
              platformChannelSpecifics,
              payload: 'task:${notificationData.contentId}',
            );
        }
      case 'COMMENT':
        await flutterLocalNotificationsPlugin.show(
          notifiId,
          '${'TASK'.tr()} ${notificationData.titleTask}',
          '${notificationData.senderName} ${'NotifiComment'.tr()} ${notificationData.titleTask}',
          platformChannelSpecifics,
          payload: 'task:${notificationData.contentId}',
        );
        break;
      case 'TEAM':
        if (notificationData.typeContent == 'LEAVE_TEAM') {
          await flutterLocalNotificationsPlugin.show(
            notifiId,
            '${'lbl_teams'.tr()} ${notificationData.titleTask}',
            '${notificationData.senderName} ${'notifi_leave'.tr()} ${notificationData.teamName}',
            platformChannelSpecifics,
            // payload: 'task:${notificationData.contentId}',
          );
        } else if (notificationData.typeContent == 'ADD_MEMBER') {
          await flutterLocalNotificationsPlugin.show(
            notifiId,
            '${'lbl_teams'.tr()} ${notificationData.titleTask}',
            '${notificationData.senderName} ${'Notifi_Add_Member'.tr()} ${notificationData.teamName} ',
            platformChannelSpecifics,
            // payload: 'task:${notificationData.contentId}',
          );
        } else if (notificationData.typeContent == 'REMOVE_MEMBER') {
          await flutterLocalNotificationsPlugin.show(
            notifiId,
            '${'lbl_teams'.tr()} ${notificationData.titleTask}',
            '${notificationData.senderName} ${'Notifi_remove_member'.tr()} ${notificationData.teamName}',
            platformChannelSpecifics,
            // payload: 'task:${notificationData.contentId}',
          );
        }
        break;
      case 'CONTACT':
        switch (notificationData.typeContent) {
          case 'CONTACT':
            await flutterLocalNotificationsPlugin.show(
              notifiId,
              '${notificationData.senderName} ${'NotifiRequest'.tr()}',
              '',
              platformChannelSpecifics,
              // payload: 'task:${notificationData.contentId}',
            );

            break;
          case 'CONTACTACEPT':
            await flutterLocalNotificationsPlugin.show(
              notifiId,
              '${notificationData.senderName} ${'NotifiAccepted'.tr()}',
              '',
              platformChannelSpecifics,
              // payload: 'task:${notificationData.contentId}',
            );
            break;
          default:
            await flutterLocalNotificationsPlugin.show(
              notifiId,
              'notifi_new'.tr(),
              'notifi_detail'.tr(),
              platformChannelSpecifics,
              // payload: 'task:${notificationData.contentId}',
            );
        }
        break;
      default:
        await flutterLocalNotificationsPlugin.show(
          notifiId,
          'notifi_new'.tr(),
          'notifi_detail'.tr(),
          platformChannelSpecifics,
          // payload: 'task:${notificationData.contentId}',
        );
=======
    if (notificationData.type == 'TASK') {
      if (notificationData.typeContent!.contains("REMOVE_ASSIGN")) {
        //Notification removee assignee
        await flutterLocalNotificationsPlugin.show(
          notifiId,
          '${'TASK'.tr()}  ${notificationData.titleTask}',
          '${notificationData.senderName} ${'NotifiRemove'.tr()} ${notificationData.titleTask}',
          platformChannelSpecifics,
        );
      } else if (notificationData.typeContent!.contains("NEW_ASSIGN")) {
        // Notification have new assignee
        await flutterLocalNotificationsPlugin.show(
          notifiId,
          '${'TASK'.tr()}  ${notificationData.titleTask}',
          '${notificationData.senderName} ${'NotifiAddTask'.tr()} ${notificationData.titleTask}',
          platformChannelSpecifics,
          payload: 'task:${notificationData.contentId}',
        );
      } else if (notificationData.typeContent!.contains("DUEAT")) {
        // Notification task due date
        await flutterLocalNotificationsPlugin.show(
          notifiId,
          '${'TASK'.tr()} ${notificationData.titleTask}',
          '${'NotifiDueAt'.tr()} ${notificationData.titleTask}',
          platformChannelSpecifics,
          payload: 'task:${notificationData.contentId}',
        );
      } else {
        // Notification report
        await flutterLocalNotificationsPlugin.show(
          notifiId,
          '${'TASK'.tr()}  ${notificationData.titleTask}',
          '${notificationData.senderName} ${'new_report'.tr()} ${notificationData.titleTask}',
          platformChannelSpecifics,
          payload: 'task:${notificationData.contentId}',
        );
      }
    } else if (notificationData.type == 'COMMENT') {
      await flutterLocalNotificationsPlugin.show(
        notifiId,
        '${'TASK'.tr()} ${notificationData.titleTask}',
        '${notificationData.senderName} ${'NotifiComment'.tr()} ${notificationData.titleTask}',
        platformChannelSpecifics,
        payload: 'task:${notificationData.contentId}',
      );
    } else {
      await flutterLocalNotificationsPlugin.show(
        notifiId,
        'friendRequest'.tr(),
        '${notificationData.senderName} ${'NotifiRequest'.tr()}',
        platformChannelSpecifics,
      );
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

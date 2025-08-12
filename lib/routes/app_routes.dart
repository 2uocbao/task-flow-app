import 'package:flutter/material.dart';
import 'package:taskflow/src/views/contact_screen/contact_screen.dart';
import 'package:taskflow/src/views/home_screen/home_screen.dart';
import 'package:taskflow/src/views/login_screen/login_screen.dart';
import 'package:taskflow/src/views/notification_screen/notification_screen.dart';
import 'package:taskflow/src/views/setting_screen/setting_screen.dart';
import 'package:taskflow/src/views/task_detail_screen/task_detail_screen.dart';
<<<<<<< HEAD
import 'package:taskflow/src/views/team_member_screen/team_member_screen.dart';
import 'package:taskflow/src/views/team_screen/team_screen.dart';
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String homeScreen = '/home_screen';
  static const String taskDetailScreen = '/task_detail_screen';
  static const String notificationScreen = '/notification_screen';
  static const String settingScreen = '/setting_screen';
<<<<<<< HEAD
  static const String teamScreen = '/team_screen';
  static const String teamMemberScreen = '/member_screen';
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  static const String contactScreen = '/contact_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        taskDetailScreen: TaskDetailScreen.builder,
        notificationScreen: NotificationScreen.builder,
        homeScreen: HomeScreen.builder,
        loginScreen: LoginScreen.builder,
        settingScreen: SettingScreen.builder,
<<<<<<< HEAD
        teamScreen: TeamScreen.builder,
        contactScreen: ConTactScreen.builder,
        teamMemberScreen: TeamMemberScreen.builder,
=======
        contactScreen: ConTactScreen.builder,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        initialRoute: LoginScreen.builder,
      };
}

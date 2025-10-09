import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/service/notification_service.dart';
import 'package:taskflow/src/utils/token_storage.dart';

var globaleMessagerKey = GlobalKey<ScaffoldMessengerState>();

final logger = Logger();

Future<void> requestNotificationPermission() async {
  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();
  await plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

void main() async {
  debugPrint = (String? message, {int? wrapWidth}) {};
  WidgetsFlutterBinding.ensureInitialized();
  await requestNotificationPermission();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await EasyLocalization.ensureInitialized();
  await PrefUtils().init();
  bool hasToken = await TokenStorage.getToken().then((value) async {
    if (value != null) {
      return true;
    }
    return false;
  });

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: TaskManagementSystem(hasToken: hasToken),
      ),
    ),
  );
}

// ignore: must_be_immutable
class TaskManagementSystem extends StatefulWidget {
  const TaskManagementSystem({super.key, required this.hasToken});

  final bool hasToken;

  @override
  State<TaskManagementSystem> createState() => _TaskManagementSystemState();
}

class _TaskManagementSystemState extends State<TaskManagementSystem> {
  @override
  void initState() {
    NotificationService().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(320, 568),
      builder: (context, state) {
        return Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            return MaterialApp(
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: provider.themeMode,
              title: 'Task Flow',
              navigatorKey: NavigatorService.navigatorKey,
              debugShowCheckedModeBanner: false,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              initialRoute: widget.hasToken
                  ? AppRoutes.homeScreen
                  : AppRoutes.loginScreen,
              routes: AppRoutes.routes,
            );
          },
        );
      },
    );
  }
}

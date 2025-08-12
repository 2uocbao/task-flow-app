import 'package:flutter/material.dart';
import 'package:taskflow/src/utils/app_export.dart';

class NavigatorService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> pushNamed(
    String routeName, {
    dynamic arguments,
  }) async {
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

<<<<<<< HEAD
  static void goBack({
    bool signals = false,
  }) {
    return navigatorKey.currentState?.pop(signals);
=======
  static void goBack() {
    return navigatorKey.currentState?.pop();
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

  static Future<dynamic> pushNamedAndRemoveUtil(
    String routeName, {
    bool routePredicate = false,
    dynamic arguments,
  }) async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (route) => routePredicate,
        arguments: arguments);
  }

  static Future<dynamic> popAndPushNamed(
    String routeName, {
    dynamic arguments,
  }) async {
    return navigatorKey.currentState
        ?.popAndPushNamed(routeName, arguments: arguments);
  }

<<<<<<< HEAD
  static void showSnackBarAndGoBack(String message) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                  ),
            ),
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        );
        navigatorKey.currentState?.pop();
      });
    }
  }

  static void showSnackBar(String message) {
=======
  static void showErrorAndGoBack(String message) {
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    final context = navigatorKey.currentContext;
    if (context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
<<<<<<< HEAD
=======
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        );
        navigatorKey.currentState?.pop();
      });
    }
  }

  static void showError(String message) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            duration: const Duration(milliseconds: 1500),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        );
      });
    }
  }
}

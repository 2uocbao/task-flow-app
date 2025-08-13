import 'package:flutter/material.dart';
import 'package:taskflow/src/utils/navigator_service.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  static void showProgressDialog(
      {BuildContext? context, bool isCancellable = false}) async {
    if (!isProgressVisible &&
        NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
      showDialog(
          barrierDismissible: isCancellable,
          context: NavigatorService.navigatorKey.currentState!.overlay!.context,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  )),
            );
          });
      isProgressVisible = true;
    }
  }

  // static void showErrorDialog({BuildContext? context, String? error}) async {
  //   showDialog(
  //     context: NavigatorService.navigatorKey.currentState!.overlay!.context,
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: Text(
  //           'No information available',
  //           style: Theme.of(context).textTheme.bodySmall,
  //         ),
  //       );
  //     },
  //   );
  // }

  static void hideProgressDialog() {
    if (isProgressVisible) {
      Navigator.pop(
          NavigatorService.navigatorKey.currentState!.overlay!.context);
      isProgressVisible = false;
    }
  }

  static void showBottomNotification(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Tự động xóa sau 5 giây
    Future.delayed(const Duration(seconds: 5))
        .then((_) => overlayEntry.remove());
  }
}

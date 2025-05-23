import 'package:taskflow/main.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  Future<void> openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      logger.i(
        'Can not launch',
      );
    }
  }
}

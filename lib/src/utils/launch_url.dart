import 'package:taskflow/src/utils/app_export.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  final _logger = Logger();
  Future<void> openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _logger.i(
        'Can not launch',
      );
    }
  }
}

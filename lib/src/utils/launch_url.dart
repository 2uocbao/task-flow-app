<<<<<<< HEAD
import 'package:taskflow/src/utils/app_export.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  final _logger = Logger();
=======
import 'package:taskflow/main.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  Future<void> openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
<<<<<<< HEAD
      _logger.i(
=======
      logger.i(
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        'Can not launch',
      );
    }
  }
}

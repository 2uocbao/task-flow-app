import 'package:url_launcher/url_launcher.dart';

bool isText(String? inputString, {bool isRequired = false}) {
  bool isInputStringValid = false;
  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }
  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^[a-zA-Z0-9 ]+$';
    final regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString);
  }
  return isInputStringValid;
}

Future<bool> isUrl(Uri url) async {
  if (await canLaunchUrl(url)) {
    return true;
  }
  return false;
}

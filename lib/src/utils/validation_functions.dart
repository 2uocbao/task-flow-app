import 'package:url_launcher/url_launcher.dart';

bool isText(String? inputString, {bool isRequired = false}) {
  bool isInputStringValid = false;
  if (!isRequired && inputString!.isEmpty) {
    isInputStringValid = true;
  }
  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r"^[\p{L}0-9\s.,!?()\-_:']+$";
    final regExp = RegExp(pattern, unicode: true);
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

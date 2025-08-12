import 'package:url_launcher/url_launcher.dart';

bool isText(String? inputString, {bool isRequired = false}) {
  bool isInputStringValid = false;
<<<<<<< HEAD
  if (!isRequired && inputString!.isEmpty) {
    isInputStringValid = true;
  }
  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r"^[\p{L}0-9\s.,!?()\-_:']+$";
    final regExp = RegExp(pattern, unicode: true);
=======
  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }
  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^[a-zA-Z0-9 ]+$';
    final regExp = RegExp(pattern);
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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

import 'dart:convert';

import 'package:flutter/services.dart';

class Utils {
<<<<<<< HEAD
=======
  List<String> typeTasks = const [
    "MYTASK",
    "ASSIGNED",
  ];

>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  List<String> typeContacts = const ["REQUESTED", "RECEIVED", "ACCEPTED"];

  List<String> statusItems = const [
    "PENDING",
<<<<<<< HEAD
    "IN_PROGRESS",
=======
    "INPROGRESS",
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    "COMPLETED",
    "CANCELLED",
  ];
  List<String> priorityItems = const ["LOW", "MEDIUM", "HIGH"];

  List<String> statusForAssigner = const [
<<<<<<< HEAD
    "IN_PROGRESS",
=======
    "INPROGRESS",
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    "COMPLETED",
    "CANCELLED"
  ];

  List<String> timeKeys = const [
    "TODAY",
    "THIS_WEEK",
    "THIS_MONTH",
    "CUSTOM",
  ];

<<<<<<< HEAD
  List<String> notifiOption = const ['ALL', 'TASK', 'CONTACT', 'COMMENT'];
=======
  List<String> notifiOption = const ['ALL', 'TASK', 'CONTACT'];
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

  Future<String?> getEnglishValue(String key) async {
    final jsonStr = await rootBundle.loadString('assets/translations/en.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonStr);
    return jsonMap[key];
  }
}

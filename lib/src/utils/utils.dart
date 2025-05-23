import 'dart:convert';

import 'package:flutter/services.dart';

class Utils {
  List<String> typeTasks = const [
    "MYTASK",
    "ASSIGNED",
  ];

  List<String> typeContacts = const ["REQUESTED", "RECEIVED", "ACCEPTED"];

  List<String> statusItems = const [
    "PENDING",
    "INPROGRESS",
    "COMPLETED",
    "CANCELLED",
  ];
  List<String> priorityItems = const ["LOW", "MEDIUM", "HIGH"];

  List<String> statusForAssigner = const ["COMPLETED", "CANCELLED"];

  List<String> timeKeys = const [
    "TODAY",
    "THIS_WEEK",
    "THIS_MONTH",
    "CUSTOM",
  ];

  List<String> notifiOption = const ['ALL', 'TASK', 'SYSTEM', 'CONTACT'];

  Future<String?> getEnglishValue(String key) async {
    final jsonStr = await rootBundle.loadString('assets/translations/en.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonStr);
    return jsonMap[key];
  }
}

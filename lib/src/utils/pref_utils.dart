import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/utils/date_time_utils.dart';

class PrefUtils {
  PrefUtils() {
    SharedPreferences.getInstance().then(
      (value) {
        _sharedPreferences = value;
      },
    );
  }

  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  void clearPreferentcesData() async {
    _sharedPreferences?.clear();
  }

  Future<void> reload() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setUser(UserData userData) {
    return _sharedPreferences!.setString('user', jsonEncode(userData.toJson()));
  }

  UserData? getUser() {
    try {
      String? jsonString = _sharedPreferences?.getString('user');
      if (jsonString == null || jsonString.isEmpty) return null;
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UserData.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

<<<<<<< HEAD
  Future<void> setTeamId(String teamId) async {
    _sharedPreferences?.setString('teamId', teamId);
  }

  String getTeamId() {
    String? teamId = _sharedPreferences!.getString('teamId');
    if (teamId == null) {
      return '';
    }
    return teamId;
=======
  Future<void> setTypeTask(String type) async {
    _sharedPreferences?.setString('taskType', type);
  }

  String getTypeTask() {
    String? typeTask = _sharedPreferences?.getString('taskType');
    if (typeTask == null) {
      return 'MYTASK';
    }
    return typeTask;
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

  Future<void> setTimeFilterTask(String type) async {
    _sharedPreferences?.setString('timeFilterTask', type);
  }

  String getTimeFilterTask() {
    String? timeFilter = _sharedPreferences!.getString('timeFilterTask');
    if (timeFilter == null) {
      return 'TODAY';
    }
    return timeFilter;
  }

  Future<void> setStatusFilterTask(String type) async {
    _sharedPreferences?.setString('statusFilterTask', type);
  }

  String getStatusFilterTask() {
    String? statusFilter = _sharedPreferences?.getString('statusFilterTask');
    if (statusFilter == null) {
      return 'PENDING';
    }
    return statusFilter;
  }

  Future<void> setPriorityFilterTask(String type) async {
    _sharedPreferences?.setString('priorityFilterTask', type);
  }

  String getPriorityFilterTask() {
    String? priorityFilter =
        _sharedPreferences!.getString('priorityFilterTask');
    if (priorityFilter == null) {
      return 'HIGH';
    }
    return priorityFilter;
  }

  Future<void> setStartDateCustom(String date) async {
    _sharedPreferences?.setString('startDate', date);
  }

  String getStartDateCustom() {
    String? startDate = _sharedPreferences!.getString('startDate');
    if (startDate == null) {
      return DateTime.now().format(pattern: D_M_Y);
    }
    return startDate;
  }

  Future<void> setEndDateCustom(String date) async {
    _sharedPreferences?.setString('endDate', date);
  }

  String getEndDateCustom() {
    String? endDate = _sharedPreferences!.getString('endDate');
    if (endDate == null) {
      return DateTime.now().format(pattern: D_M_Y);
    }
    return endDate;
  }

  Future<void> setOptionContact(String option) async {
    _sharedPreferences?.setString('optionContact', option);
  }

  String getOptionsContact() {
    String? option = _sharedPreferences!.getString('optionContact');
    if (option == null) {
      return 'ACCEPTED';
    }
    return option;
  }

  Future<void> setTypeNotifi(String type) async {
    _sharedPreferences?.setString('typeNotifi', type);
  }

  String getTypeNotifi() {
    String? type = _sharedPreferences!.getString('typeNotifi');
    if (type == null) {
      return 'ALL';
    }
    return type;
  }

  Future<void> setReadNotifi(bool type) async {
    _sharedPreferences?.setBool('isRead', type);
  }

  bool getReadNotifi() {
    bool? type = _sharedPreferences!.getBool('isRead');
    if (type == null) {
      return true;
    }
    return type;
  }
}

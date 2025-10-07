import 'package:taskflow/src/data/model/task/status_summary.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/data/model/team/team_data.dart';

class HomeData {
  List<TeamData>? teamData = <TeamData>[];
  List<StatusSummary>? statusSummary = <StatusSummary>[];
  List<TaskData>? taskData = <TaskData>[];

  HomeData({this.teamData, this.statusSummary, this.taskData});

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['teams'] != null) {
      teamData = (json['teams'] as List)
          .map((value) => TeamData.fromJson(value))
          .toList();
    }
    if (json['status_summary'] != null) {
      statusSummary = (json['status_summary'] as List)
          .map((value) => StatusSummary.fromJson(value))
          .toList();
    }
    if (json['tasks'] != null) {
      taskData = (json['tasks'] as List)
          .map((value) => TaskData.fromJson(value))
          .toList();
    }
  }
}

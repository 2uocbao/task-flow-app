import 'package:taskflow/src/data/model/task/status_summary.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/data/model/team/team_data.dart';

class HomeData {
  List<TeamData>? teamData;
  List<StatusSummary>? statusSummary;
  List<TaskData>? taskData;

  HomeData({this.teamData, this.statusSummary, this.taskData});

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['teams'] != null) {
      teamData = <TeamData>[];
      json['teams'].forEach((value) {
        teamData?.add(TeamData.fromJson(value));
      });
    }
    if (json['status_summary'] != null) {
      statusSummary = <StatusSummary>[];
      json['status_summary'].forEach((value) {
        statusSummary?.add(StatusSummary.fromJson(value));
      });
    }
    if (json['tasks'] != null) {
      taskData = <TaskData>[];
      json['tasks'].forEach((value) {
        taskData?.add(TaskData.fromJson(value));
      });
    }
  }
}

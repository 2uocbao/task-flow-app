import 'package:taskflow/src/data/model/comment/comment_data.dart';
import 'package:taskflow/src/data/model/report/report_data.dart';
import 'package:taskflow/src/data/model/task/assign_data.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';

class TaskDetailCustom {
  TaskData? taskData;
  List<AssignData>? listAssigns;
  List<ReportData>? listReports;
  List<CommentData>? listComments;

  TaskDetailCustom({
    this.taskData,
    this.listAssigns,
    this.listReports,
    this.listComments,
  });

  TaskDetailCustom.fromJson(Map<String, dynamic> json) {
    if (json['task'] != null) {
      taskData = TaskData.fromJson(json['task']);

      ///
      if (json['assigners'] != null) {
        listAssigns = [];
        json['assigners'].forEach((value) {
          listAssigns?.add(AssignData.fromJson(value));
        });
      }
      if (json['reports'] != null) {
        listReports = [];
        json['reports'].forEach((value) {
          listReports?.add(ReportData.fromJson(value));
        });
      }
      if (json['comments'] != null) {
        listComments = [];
        json['comments'].forEach((value) {
          listComments?.add(CommentData.fromJson(value));
        });
      }
    }
  }
}

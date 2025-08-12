import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskflow/src/data/model/comment/comment_data.dart';
import 'package:taskflow/src/data/model/report/report_data.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/comment_task_widget.dart';

// ignore: must_be_immutable
class TaskDetailModel extends Equatable {
  TaskData taskData;
  List<CommentData> commentDatas;
  List<ReportData> reportOfPhoto;
  List<ReportData> reportOfLink;
  List<ReportData> reportOfFile;
  Map<int, GlobalKey<CommentTaskWidgetState>> commentKeys;

  TaskDetailModel({
    this.commentDatas = const [],
    this.reportOfPhoto = const [],
    this.reportOfLink = const [],
    this.reportOfFile = const [],
    required this.taskData,
    this.commentKeys = const {},
  });

  TaskDetailModel copyWith({
    TaskData? taskData,
    List<CommentData>? commentDatas,
    List<ReportData>? reportOfPhoto,
    List<ReportData>? reportOfLink,
    List<ReportData>? reportOfFile,
    Map<int, GlobalKey<CommentTaskWidgetState>>? commentKeys,
  }) {
    return TaskDetailModel(
      taskData: taskData ?? this.taskData,
      commentDatas: commentDatas ?? this.commentDatas,
      reportOfPhoto: reportOfPhoto ?? this.reportOfPhoto,
      reportOfLink: reportOfLink ?? this.reportOfLink,
      reportOfFile: reportOfFile ?? this.reportOfFile,
      commentKeys: commentKeys ?? this.commentKeys,
    );
  }

  @override
  List<Object?> get props => [
        taskData,
        commentDatas,
        reportOfPhoto,
        reportOfLink,
        reportOfFile,
        commentKeys
      ];
}

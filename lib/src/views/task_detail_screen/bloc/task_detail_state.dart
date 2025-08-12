import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/model/comment/comment_data.dart';
import 'package:taskflow/src/data/model/report/report_data.dart';
import 'package:taskflow/src/data/model/task/assign_data.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/comment_task_widget.dart';

class TaskDetailState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchTaskLoading extends TaskDetailState {}

class TaskDetailErrorState extends TaskDetailState {
  final String error;
  TaskDetailErrorState(this.error);
}

class FetchTaskSuccess extends TaskDetailState {
  final bool hasMoreComment;
  final List<AssignData> listAssigns;

  final TaskData taskData;
  final List<CommentData> commentDatas;
  final List<ReportData> reportOfPhoto;
  final List<ReportData> reportOfLink;
  final List<ReportData> reportOfFile;
  final List<Map<String, dynamic>> mentionData;
  final Map<int, GlobalKey<CommentTaskWidgetState>> commentKeys;

  FetchTaskSuccess({
    required this.hasMoreComment,
    required this.listAssigns,
    required this.taskData,
    required this.commentDatas,
    required this.reportOfPhoto,
    required this.reportOfLink,
    required this.reportOfFile,
    required this.mentionData,
    required this.commentKeys,
  });

  FetchTaskSuccess copyWith({
    bool? hasMoreComment,
    List<AssignData>? listAssigns,
    TaskData? taskData,
    List<CommentData>? commentDatas,
    List<ReportData>? reportOfPhoto,
    List<ReportData>? reportOfFile,
    List<ReportData>? reportOfLink,
    List<Map<String, dynamic>>? mentionData,
    Map<int, GlobalKey<CommentTaskWidgetState>>? commentKeys,
  }) {
    return FetchTaskSuccess(
      hasMoreComment: hasMoreComment ?? this.hasMoreComment,
      listAssigns: listAssigns ?? this.listAssigns,
      taskData: taskData ?? this.taskData,
      commentDatas: commentDatas ?? this.commentDatas,
      reportOfPhoto: reportOfPhoto ?? this.reportOfPhoto,
      reportOfFile: reportOfFile ?? this.reportOfFile,
      commentKeys: commentKeys ?? this.commentKeys,
      mentionData: mentionData ?? this.mentionData,
      reportOfLink: reportOfLink ?? this.reportOfLink,
    );
  }

  @override
  List<Object?> get props => [
        taskData,
        hasMoreComment,
        listAssigns,
        taskData,
        commentDatas,
        reportOfPhoto,
        reportOfFile,
        commentKeys,
        mentionData,
        reportOfLink
      ];
}

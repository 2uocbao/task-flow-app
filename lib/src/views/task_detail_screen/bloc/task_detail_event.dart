import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/report/report_data.dart';

class TaskDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDetailEvent extends TaskDetailEvent {
  final String id;
  FetchDetailEvent({required this.id});
}

class ReloadComments extends TaskDetailEvent {
  final String taskId;
  ReloadComments({required this.taskId});
}

class UpdateTaskEvent extends TaskDetailEvent {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  UpdateTaskEvent(
      {required this.id,
      required this.title,
      required this.description,
      required this.status,
      required this.priority});
}

class FetchCommentEvent extends TaskDetailEvent {
  final String taskId;
  FetchCommentEvent({required this.taskId});
}

class UpdateCommentEvent extends TaskDetailEvent {
  final int commentId;
  final String text;
  UpdateCommentEvent({required this.commentId, required this.text});
}

class UpdateDueAtTaskEvent extends TaskDetailEvent {
  final DateTime dateTime;
  UpdateDueAtTaskEvent(this.dateTime);
}

class UpdateStartAtTaskEvent extends TaskDetailEvent {
  final DateTime dateTime;
  UpdateStartAtTaskEvent(this.dateTime);
}

class AddCommentEvent extends TaskDetailEvent {
  final String content;
  AddCommentEvent(this.content);
}

class AttachmentsEvent extends TaskDetailEvent {
  final File file;
  AttachmentsEvent({required this.file});
}

class AttachmentsURLEvent extends TaskDetailEvent {
  final String url;
  AttachmentsURLEvent({required this.url});
}

class DownloadFileEvent extends TaskDetailEvent {
  final String fileName;
  final String reportId;
  DownloadFileEvent({required this.fileName, required this.reportId});
}

class OpenUrlEvent extends TaskDetailEvent {
  final String url;
  OpenUrlEvent(this.url);
}

class OpenFileEvent extends TaskDetailEvent {
  final ReportData reportData;
  OpenFileEvent(this.reportData);
}

class AssignTaskEvent extends TaskDetailEvent {
  final String toUserId;
  final String assigerName;
  final String pathImage;
  AssignTaskEvent(
      {required this.toUserId,
      required this.assigerName,
      required this.pathImage});
}

class RemoveAssignEvent extends TaskDetailEvent {
  final String assignId;
  RemoveAssignEvent({required this.assignId});
}

class SearchContactEvent extends TaskDetailEvent {
  final String keySearch;
  SearchContactEvent(this.keySearch);
}

class UpdateStatusEvent extends TaskDetailEvent {
  final String status;
  UpdateStatusEvent(this.status);
}

class UpdatePriorityEvent extends TaskDetailEvent {
  final String priority;
  UpdatePriorityEvent(this.priority);
}

class FetchMentionEvent extends TaskDetailEvent {
  final String userId;
  FetchMentionEvent(this.userId);
}

import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_model.dart';

// ignore: must_be_immutable
class TaskDetailState extends Equatable {
  TaskDetailModel taskDetailModel;
  bool hasMoreComment;
  List<UserData> contactResult;

  TaskDetailState({
    required this.taskDetailModel,
    this.hasMoreComment = false,
    this.contactResult = const [],
  });

  TaskDetailState copyWith({
    TaskDetailModel? taskDetailModel,
    bool? hasMoreComment,
    List<UserData>? contactResult,
  }) {
    return TaskDetailState(
      taskDetailModel: taskDetailModel ?? this.taskDetailModel,
      hasMoreComment: hasMoreComment ?? this.hasMoreComment,
      contactResult: contactResult ?? this.contactResult,
    );
  }

  @override
  List<Object?> get props => [taskDetailModel, hasMoreComment, contactResult];
}

// ignore: must_be_immutable
class AddCommentSuccess extends TaskDetailState {
  AddCommentSuccess({required super.taskDetailModel});
}

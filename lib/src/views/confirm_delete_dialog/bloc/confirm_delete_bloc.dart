import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/bloc/confirm_delete_event.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/bloc/confirm_delete_state.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_arguments.dart';

class ConfirmDeleteBloc extends Bloc<ConfirmDeleteEvent, ConfirmDeleteState> {
  ConfirmDeleteBloc(super.initial) {
    on<RequestDeleteTaskEvent>(_onDeleteTask);
    on<RequestDeleteCommentEvent>(_onDeleteComment);
    on<RequestDeleteReportEvent>(_onDeleteReport);
  }

  final _repository = Repository();

  _onDeleteTask(
    RequestDeleteTaskEvent event,
    Emitter<ConfirmDeleteState> emit,
  ) async {
    await _repository
        .deleteTask(state.customId!.taskId!, PrefUtils().getUser()!.id!)
        .then((value) {
      if (value.statusCode == 200) {
        NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
      } else {
        NavigatorService.showErrorAndGoBack("lbl_error".tr());
      }
    }).onError((error, stackTrace) {});
  }

  _onDeleteComment(
    RequestDeleteCommentEvent event,
    Emitter<ConfirmDeleteState> emit,
  ) async {
    await _repository
        .deleteComment(
            PrefUtils().getUser()!.id!, int.parse(state.customId!.commentId!))
        .then((value) {
      if (value.statusCode == 200) {
        NavigatorService.pushNamedAndRemoveUtil(AppRoutes.taskDetailScreen,
            arguments: TaskDetailArguments(taskId: state.customId!.taskId));
      } else {
        NavigatorService.showErrorAndGoBack("lbl_error".tr());
      }
    });
  }

  _onDeleteReport(
    RequestDeleteReportEvent event,
    Emitter<ConfirmDeleteState> emit,
  ) async {
    await _repository
        .deleteReport(PrefUtils().getUser()!.id!, state.customId!.taskId!,
            state.customId!.reportId!)
        .then((value) {
      if (value.statusCode == 200) {
        NavigatorService.pushNamedAndRemoveUtil(AppRoutes.taskDetailScreen,
            arguments: TaskDetailArguments(taskId: state.customId!.taskId));
      } else {
        NavigatorService.showErrorAndGoBack("lbl_error".tr());
      }
    });
  }
}

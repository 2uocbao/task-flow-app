import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/routes/app_routes.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/navigator_service.dart';
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
        .deleteTask(state.customId!.taskId!, 'DYpaP8')
        .then((value) {
      if (value.statusCode == 200) {
        NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
      }
    }).onError((error, stackTrace) {});
  }

  _onDeleteComment(
    RequestDeleteCommentEvent event,
    Emitter<ConfirmDeleteState> emit,
  ) async {
    await _repository
        .deleteComment('DYpaP8', int.parse(state.customId!.commentId!))
        .then((value) {
      if (value.statusCode == 200) {
        NavigatorService.pushNamedAndRemoveUtil(AppRoutes.taskDetailScreen,
            arguments: TaskDetailArguments(taskId: state.customId!.taskId));
      }
    });
  }

  _onDeleteReport(
    RequestDeleteReportEvent event,
    Emitter<ConfirmDeleteState> emit,
  ) async {
    await _repository
        .deleteReport(
            'DYpaP8', state.customId!.taskId!, state.customId!.reportId!)
        .then((value) {
      if (value.statusCode == 200) {
        NavigatorService.pushNamedAndRemoveUtil(AppRoutes.taskDetailScreen,
            arguments: TaskDetailArguments(taskId: state.customId!.taskId));
      }
    });
  }
}

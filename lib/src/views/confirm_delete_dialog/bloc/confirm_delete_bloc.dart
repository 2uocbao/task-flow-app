import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/repository/repository.dart';
<<<<<<< HEAD
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
import 'package:taskflow/src/views/confirm_delete_dialog/bloc/confirm_delete_event.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/bloc/confirm_delete_state.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_arguments.dart';

class ConfirmDeleteBloc extends Bloc<ConfirmDeleteEvent, ConfirmDeleteState> {
  ConfirmDeleteBloc(super.initial) {
    on<RequestDeleteTaskEvent>(_onDeleteTask);
    on<RequestDeleteCommentEvent>(_onDeleteComment);
    on<RequestDeleteReportEvent>(_onDeleteReport);
<<<<<<< HEAD
    on<RequestDeleteTeamEvent>(_onDeleteTeam);
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

  final _repository = Repository();

<<<<<<< HEAD
  Future<void> _onDeleteTask(
    RequestDeleteTaskEvent event,
    Emitter<ConfirmDeleteState> emit,
  ) async {
    try {
      await _repository.deleteTask(state.customId!.taskId!).then((value) {
        if (value.statusCode == 200) {
          NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
        } else if (value.statusCode == 409) {
          NavigatorService.showSnackBarAndGoBack('error_task_have_assign'.tr());
        } else {
          NavigatorService.showSnackBarAndGoBack('lbl_error'.tr());
        }
      }).onError((error, stackTrace) {
        NavigatorService.showSnackBarAndGoBack('lbl_error'.tr());
      });
    } catch (e) {
      if (e is NoInternetException) {
        NavigatorService.showSnackBarAndGoBack('error_no_internet'.tr());
      } else {
        NavigatorService.showSnackBarAndGoBack('lbl_error'.tr());
      }
    }
  }

  Future<void> _onDeleteComment(
    RequestDeleteCommentEvent event,
    Emitter<ConfirmDeleteState> emit,
  ) async {
    try {
      await _repository
          .deleteComment(int.parse(state.customId!.commentId!))
          .then((value) {
        if (value.statusCode == 200) {
          NavigatorService.pushNamedAndRemoveUtil(AppRoutes.taskDetailScreen,
              arguments: TaskDetailArguments(taskId: state.customId!.taskId));
        } else {
          NavigatorService.showSnackBarAndGoBack('lbl_error'.tr());
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        NavigatorService.showSnackBarAndGoBack('error_no_internet'.tr());
      } else {
        NavigatorService.showSnackBarAndGoBack('lbl_error'.tr());
      }
    }
  }

  Future<void> _onDeleteReport(
    RequestDeleteReportEvent event,
    Emitter<ConfirmDeleteState> emit,
  ) async {
    try {
      await _repository
          .deleteReport(state.customId!.taskId!, state.customId!.reportId!)
          .then((value) {
        if (value.statusCode == 200) {
          NavigatorService.pushNamedAndRemoveUtil(AppRoutes.taskDetailScreen,
              arguments: TaskDetailArguments(taskId: state.customId!.taskId));
        } else {
          NavigatorService.showSnackBarAndGoBack('lbl_error'.tr());
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        NavigatorService.showSnackBarAndGoBack('error_no_internet'.tr());
      } else {
        NavigatorService.showSnackBarAndGoBack('lbl_error'.tr());
      }
    }
  }

  Future<void> _onDeleteTeam(
    RequestDeleteTeamEvent event,
    Emitter<ConfirmDeleteState> emit,
  ) async {
    try {
      await _repository.deleteTeam(state.customId!.teamId!).then((value) async {
        if (value.statusCode == 200) {
          NavigatorService.pushNamedAndRemoveUtil(AppRoutes.teamScreen);
        } else if (value.statusCode == 409) {
          NavigatorService.showSnackBarAndGoBack('error_409_delete_team'.tr());
        } else {
          NavigatorService.showSnackBarAndGoBack('lbl_error'.tr());
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        NavigatorService.showSnackBarAndGoBack('error_no_internet'.tr());
      } else {
        NavigatorService.showSnackBarAndGoBack('lbl_error'.tr());
      }
    }
=======
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
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }
}

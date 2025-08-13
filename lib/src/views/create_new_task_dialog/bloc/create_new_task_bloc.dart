
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/model/response/response_data.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';

import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
import 'package:taskflow/src/views/create_new_task_dialog/bloc/create_new_task_event.dart';
import 'package:taskflow/src/views/create_new_task_dialog/bloc/create_new_task_state.dart';

class CreateNewTaskBloc extends Bloc<CreateNewTaskEvent, CreateNewTaskState> {
  CreateNewTaskBloc(super.initialState) {
    on<CreateNewTaskEvent>(_createTask);
  }

  final _repository = Repository();

  Future<void> _createTask(
    CreateNewTaskEvent event,
    Emitter<CreateNewTaskState> emit,
  ) async {
    var taskBody = TaskData(
      creatorId: PrefUtils().getUser()!.id,
      title: event.title,
      description: event.description,
      priority: event.priority,
      dueAt: event.dueAt,
    );
    String teamId = PrefUtils().getTeamId();
    try {
      await _repository
          .createTask(teamId, requestData: taskBody.toJson())
          .then((value) async {
        ResponseData responseData =
            ResponseData.fromJson(value.data, TaskData.fromJson);
        if (responseData.status == 200) {
          emit(CreateNewTaskSuccessState());
        } else {
          emit(
            CreateNewTaskErrorState(error: responseData.message!),
          );
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(
          CreateNewTaskErrorState(error: 'error_no_internet'.tr()),
        );
      } else {
        emit(
          CreateNewTaskErrorState(error: 'lbl_error'.tr()),
        );
      }
    }
  }
}

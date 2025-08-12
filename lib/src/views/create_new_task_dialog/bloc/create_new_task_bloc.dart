<<<<<<< HEAD
import 'package:easy_localization/easy_localization.dart';
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/model/response/response_data.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
<<<<<<< HEAD
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
import 'package:taskflow/src/views/create_new_task_dialog/bloc/create_new_task_event.dart';
import 'package:taskflow/src/views/create_new_task_dialog/bloc/create_new_task_state.dart';

class CreateNewTaskBloc extends Bloc<CreateNewTaskEvent, CreateNewTaskState> {
  CreateNewTaskBloc(super.initialState) {
<<<<<<< HEAD
    on<CreateNewTaskEvent>(_createTask);
  }

  final _repository = Repository();

  Future<void> _createTask(
    CreateNewTaskEvent event,
=======
    on<CreateNewTaskInitialEvent>(_onInitialize);
    on<ChangeDateEvent>(_changeDate);
    on<CreateTaskEvent>(_createTask);
    on<ChangePriorityEvent>(_changePriority);
  }

  Logger logger = Logger();

  final _repository = Repository();

  _onInitialize(
    CreateNewTaskInitialEvent event,
    Emitter<CreateNewTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        taskNameInputController: TextEditingController(),
        taskDescriptionInputController: TextEditingController(),
        taskDueAtInputController: TextEditingController(
            text: DateTime.now().format(pattern: D_M_Y_HH_mm)),
      ),
    );
  }

  _changeDate(
    ChangeDateEvent event,
    Emitter<CreateNewTaskState> emit,
  ) {
    emit(
      state.copyWith(
        taskDueAtInputController: TextEditingController(
          text: event.date.format(pattern: D_M_Y_HH_mm),
        ),
      ),
    );
  }

  Future<void> _createTask(
    CreateTaskEvent event,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    Emitter<CreateNewTaskState> emit,
  ) async {
    var taskBody = TaskData(
      creatorId: PrefUtils().getUser()!.id,
<<<<<<< HEAD
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
=======
      title: state.taskNameInputController?.text,
      description: state.taskDescriptionInputController?.text ?? '',
      priority: state.priority ?? '',
      dueAt: state.taskDueAtInputController?.text,
    );
    logger.i(taskBody.toJson());
    await _repository
        .createTask(requestData: taskBody.toJson())
        .then((value) async {
      ResponseData responseData =
          ResponseData.fromJson(value.data, TaskData.fromJson);
      if (responseData.status == 200) {
        emit(
          CreateNewTaskSuccessState(isSuccess: true),
        );
      } else {
        emit(
          CreateNewTaskErrorState(error: responseData.message!),
        );
      }
    });
  }

  _changePriority(
    ChangePriorityEvent event,
    Emitter<CreateNewTaskState> emit,
  ) async {
    logger.i(event.priority);
    emit(
      state.copyWith(
        priority: event.priority,
      ),
    );
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }
}

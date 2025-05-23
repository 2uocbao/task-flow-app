import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/utils/pref_utils.dart';
import 'package:taskflow/src/views/home_screen/bloc/home_event.dart';
import 'package:taskflow/src/views/home_screen/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(super.initialState) {
    on<FetchDataEvent>(_getTasks);
    on<ChangeTypeEvent>(_onChangeType);
    on<SearchTaskEvent>(_onSearchTask);
  }

  Logger logger = Logger();

  final _repository = Repository();

  int currentPage = 0;

  Future<void> _getTasks(
    FetchDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.hasMore) {
      return;
    } else {
      Map<String, dynamic> queryParam = <String, dynamic>{
        'status': PrefUtils().getStatusFilterTask(),
        'assign': _typeTaskRequest().toString(),
        'priority': PrefUtils().getPriorityFilterTask(),
        'startDate': '${PrefUtils().getStartDateCustom()} 00:00'.toString(),
        'endDate': '${PrefUtils().getEndDateCustom()} 23:59'.toString(),
        'page': currentPage,
        'size': 10,
      };

      await _repository
          .getTasks(PrefUtils().getUser()!.id!, queryParam: queryParam)
          .then(
        (value) async {
          ResponseList<TaskData> responseList =
              ResponseList.fromJson(value.data, TaskData.fromJson);
          emit(
            state.copyWith(
              homeInitialModel: state.homeInitialModel.copyWith(
                listTasks: [
                  ...state.homeInitialModel.listTasks,
                  ...?responseList.data
                ],
              ),
              hasMore: responseList.pagination!.currentPage! ==
                  responseList.pagination!.totalPages! - 1,
            ),
          );
        },
      ).onError((error, stackTrace) {});
      currentPage++;
    }
  }

  Future<void> _onChangeType(
    ChangeTypeEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (event.type != PrefUtils().getTypeTask()) {
      currentPage = 0;
      emit(
        state.copyWith(
          homeInitialModel: state.homeInitialModel.copyWith(
            selectedType: event.type,
            listTasks: [],
          ),
          hasMore: false,
        ),
      );
      PrefUtils().setTypeTask(event.type);
      add(FetchDataEvent());
    }
  }

  _onSearchTask(
    SearchTaskEvent event,
    Emitter<HomeState> emit,
  ) async {
    final requestParam = <String, dynamic>{
      'keySearch': event.keySearch,
      'type': _typeTaskRequest(),
      'size': 10,
    };
    await _repository
        .searchTask(PrefUtils().getUser()!.id!, queryParam: requestParam)
        .then(
      (value) async {
        ResponseList<TaskData> responseList =
            ResponseList.fromJson(value.data, TaskData.fromJson);
        emit(
          state.copyWith(
            resultSearch: responseList.data ?? [],
          ),
        );
      },
    );
  }

  bool _typeTaskRequest() {
    if (PrefUtils().getTypeTask() != 'MYTASK') {
      return true;
    }
    return false;
  }
}

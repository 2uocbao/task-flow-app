import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/home/home_data.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
import 'package:taskflow/src/utils/token_storage.dart';
import 'package:taskflow/src/views/home_screen/bloc/home_event.dart';
import 'package:taskflow/src/views/home_screen/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(super.initialState) {
    on<FetchDataEvent>(_getAllData);
    on<FetchTaskEvent>(_getTasks);
    on<SelectedStatusEvent>(_onSelectedStatus);
    on<SelectedTeamEvent>(_onSelectedTeam);
    on<SearchTaskEvent>(_onSearchTask);
    on<LogoutEvent>(_onLogout);
  }

  final _repository = Repository();

  final logger = Logger();

  int currentPage = 0;

  Future<void> _getAllData(
    FetchDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoadingState());
      Map<String, dynamic> queryParam = <String, dynamic>{
        'teamId': PrefUtils().getTeamId(),
        'status': PrefUtils().getStatusFilterTask().toUpperCase(),
        'priority': PrefUtils().getPriorityFilterTask().toUpperCase(),
        'startDate': '${PrefUtils().getStartDateCustom()} 00:00'.toString(),
        'endDate': '${PrefUtils().getEndDateCustom()} 23:59'.toString(),
        'page': 0,
        'size': 10,
      };
      await _repository.getHome(queryParam: queryParam).then((value) async {
        if (value.statusCode == 200) {
          if (value.data['data'] != null) {
            List<dynamic> dataList = value.data['data'];
            ResponseList<HomeData> homeData =
                ResponseList.fromJson(value.data, HomeData.fromJson);
            HomeData homeData2 = HomeData.fromJson(dataList.first);

            emit(HomeFetchSuccessState(
              selectedTeam: PrefUtils().getTeamId(),
              selectedStatus: PrefUtils().getStatusFilterTask(),
              listTeams: homeData2.teamData!,
              listStatusSummary: homeData2.statusSummary!,
              listTasks: homeData2.taskData!,
              hasMore: homeData.pagination!.currentPage! ==
                  homeData.pagination!.totalPages! - 1,
            ));
          } else {
            emit(HomeNullDataState());
          }
        } else {
          emit(HomeFailureState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(HomeFailureState('error_no_internet'.tr()));
      } else {
        emit(HomeFailureState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _getTasks(
    FetchTaskEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeFetchSuccessState) {
        final successState = state as HomeFetchSuccessState;
        if (successState.hasMore) {
          return;
        } else {
          Map<String, dynamic> queryParam = <String, dynamic>{
            'teamId': PrefUtils().getTeamId(),
            'status': PrefUtils().getStatusFilterTask().toUpperCase(),
            'priority': PrefUtils().getPriorityFilterTask().toUpperCase(),
            'startDate': '${PrefUtils().getStartDateCustom()} 00:00'.toString(),
            'endDate': '${PrefUtils().getEndDateCustom()} 23:59'.toString(),
            'page': currentPage,
            'size': 10,
          };
          String teamId = PrefUtils().getTeamId();
          await _repository
              .getTasks(teamId, queryParam: queryParam)
              .then((value) async {
            if (value.statusCode == 200) {
              ResponseList<TaskData> responseList =
                  ResponseList.fromJson(value.data, TaskData.fromJson);

              final fetchMoreTask = [
                ...successState.listTasks,
                ...(responseList.data!)
              ];

              emit(successState.copyWith(
                selectedTeam: PrefUtils().getTeamId(),
                selectedStatus: PrefUtils().getStatusFilterTask(),
                listTasks: fetchMoreTask,
                hasMore: responseList.pagination!.currentPage! ==
                    responseList.pagination!.totalPages! - 1,
              ));
              currentPage++;
            }
          });
        }
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(HomeFailureState('error_no_internet'.tr()));
      } else {
        emit(HomeFailureState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onSelectedStatus(
    SelectedStatusEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeFetchSuccessState) {
      final successState = state as HomeFetchSuccessState;

      if (event.status != PrefUtils().getStatusFilterTask()) {
        currentPage = 0;

        emit(successState.copyWith(
          selectedTeam: PrefUtils().getTeamId(),
          selectedStatus: event.status,
          listTasks: [],
          hasMore: false,
        ));
        PrefUtils().setStatusFilterTask(event.status);
        add(FetchTaskEvent());
      }
    }
  }

  Future<void> _onSelectedTeam(
    SelectedTeamEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeFetchSuccessState) {
      final successState = state as HomeFetchSuccessState;
      if (event.team != PrefUtils().getTeamId()) {
        currentPage = 0;
        emit(successState.copyWith(
          selectedTeam: event.team,
          selectedStatus: PrefUtils().getStatusFilterTask(),
          listStatusSummary: [],
          listTasks: [],
          hasMore: false,
        ));
        PrefUtils().setTeamId(event.team);
        add(FetchDataEvent());
      }
    }
  }

  Future<void> _onSearchTask(
    SearchTaskEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final requestParam = <String, dynamic>{
        'keyword': event.keySearch,
        'size': 10,
      };
      await _repository.searchTask(queryParam: requestParam).then(
        (value) async {
          ResponseList<TaskData> responseList =
              ResponseList.fromJson(value.data, TaskData.fromJson);
          final successState = state as HomeFetchSuccessState;

          emit(successState.copyWith(
            resultSearch: responseList.data!,
          ));
        },
      );
    } catch (e) {
      if (e is NoInternetException) {
        emit(HomeFailureState('error_no_internet'.tr()));
      } else {
        emit(HomeFailureState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _repository.removeToken().then((value) async {
      PrefUtils().clearPreferentcesData();
      await TokenStorage.deleteToken();
      await TokenStorage.deleteRefresh();
      NavigatorService.pushNamedAndRemoveUtil(AppRoutes.loginScreen);
    });
  }
}

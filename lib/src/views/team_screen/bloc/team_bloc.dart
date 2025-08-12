import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/model/team/team_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
import 'package:taskflow/src/views/team_screen/bloc/team_event.dart';
import 'package:taskflow/src/views/team_screen/bloc/team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  TeamBloc(super.initialState) {
    on<FetchTeamEvent>(_onFetchTeam);
    on<UpdateTeamEvent>(_onUpdateTeam);
    on<AddMemberEvent>(_onAddMember);
    on<SearchTeamEvent>(_onSearchTeam);
    on<LeaveTeamEvent>(_onLeaveTeam);
  }

  final _repository = Repository();

  final _logger = Logger();

  Future<void> _onFetchTeam(
    FetchTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      emit(FetchDataLoading());
      await _repository.getTeams().then((value) async {
        if (value.statusCode == 200) {
          ResponseList<TeamData> response =
              ResponseList.fromJson(value.data, TeamData.fromJson);
          emit(FetchDataSuccess(
            teamData: response.data!,
          ));
        } else {
          emit(TeamErrorState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(TeamErrorState('error_no_internet'.tr()));
      } else {
        emit(TeamErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onAddMember(
    AddMemberEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      var requestData = <String, dynamic>{
        'member_id': event.contactData.userId,
        'leader_name': event.teamData.creatorName,
        'team_name': event.teamData.name,
      };
      _logger.i(requestData.toString());
      await _repository
          .addMemberToTeam(event.teamData.id!, requestData: requestData)
          .then((value) async {
        if (value.statusCode == 200) {
          // emit(TeamSuccessState('lbl_add_success'.tr()));
          NavigatorService.showSnackBar('lbl_add_success'.tr());
        } else {
          switch (value.statusCode) {
            case 403:
              emit(TeamErrorState('error_403'.tr()));
              break;
            case 404:
              emit(TeamErrorState('error_user_not_found'.tr()));
              break;
            case 409:
              emit(TeamErrorState('error_409_already_exist_member'.tr()));
              break;
            default:
              emit(TeamErrorState('lbl_error'.tr()));
              return;
          }
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(TeamErrorState('error_no_internet'.tr()));
      } else {
        emit(TeamErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onUpdateTeam(
    UpdateTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      await _repository
          .updateTeam(event.teamId,
              requestData: TeamData(name: event.newName).toJson())
          .then((value) async {
        if (value.statusCode == 200) {
          final successState = state as FetchDataSuccess;
          final teamAfterUpdate = List.of(successState.teamData).map((team) {
            if (team.id == event.teamId) {
              return team.copyWith(name: event.newName);
            }
            return team;
          }).toList();
          emit(successState.copyWith(teamData: teamAfterUpdate));
        } else {
          emit(TeamErrorState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(TeamErrorState('error_no_internet'.tr()));
      } else {
        emit(TeamErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onSearchTeam(
    SearchTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      var queryParam = <String, dynamic>{
        'keyword': event.keySearch,
      };
      try {
        await _repository.searchTeam(queryParam: queryParam).then((value) {
          if (value.statusCode == 200) {
            ResponseList<TeamData> teamDataResponse =
                ResponseList.fromJson(value.data, TeamData.fromJson);
            final successState = state as FetchDataSuccess;
            emit(
                successState.copyWith(teamSearchResult: teamDataResponse.data));
          } else {
            NavigatorService.showSnackBar('lbl_error'.tr());
          }
        });
      } catch (e) {
        _logger.e(e.toString());
        emit(TeamErrorState('lbl_error'.tr()));
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(TeamErrorState('error_no_internet'.tr()));
      } else {
        emit(TeamErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onLeaveTeam(
    LeaveTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      UserData userData = PrefUtils().getUser()!;
      var requestData = <String, dynamic>{
        'member_id': null,
        'leader_name': userData.firstName! + userData.lastName!,
        'team_name': event.teamData.name,
      };
      await _repository
          .leaveTeam(event.teamData.id!, requestData: requestData)
          .then((value) async {
        if (value.statusCode == 200) {
          final successState = state as FetchDataSuccess;
          final listTeamAfter = List.of(successState.teamData)
            ..removeWhere(
              (team) => team.id == event.teamData.id,
            );
          emit(successState.copyWith(teamData: listTeamAfter));
        } else if (value.statusCode == 409) {
          emit(TeamErrorState('error_409_member_leave_team'.tr()));
        } else {
          emit(TeamErrorState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(TeamErrorState('error_no_internet'.tr()));
      } else {
        emit(TeamErrorState('lbl_error'.tr()));
      }
    }
  }
}

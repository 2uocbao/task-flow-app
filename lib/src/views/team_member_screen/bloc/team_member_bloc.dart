import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/response/response_data.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/model/team_member/member_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
import 'package:taskflow/src/views/team_member_screen/bloc/team_member_event.dart';
import 'package:taskflow/src/views/team_member_screen/bloc/team_member_state.dart';

class TeamMemberBloc extends Bloc<TeamMemberEvent, TeamMemberState> {
  TeamMemberBloc(super.initialState) {
    on<FetchTeamMemberEvent>(_onFetchMember);
    on<AddMemberEvent>(_onAddMember);
    on<RemoveMemberEvent>(_onRemoveMember);
    on<SearchMemberEvent>(_onSearchMember);
    on<SearchMemberOffEvent>(_onSearchOff);
    on<TeamMemberInitialEvent>(_onInitial);
  }

  final _repository = Repository();

  void _onInitial(
    TeamMemberInitialEvent event,
    Emitter<TeamMemberState> emit,
  ) {
    emit(TeamMemberSuccess(memberDatas: const []));
  }

  Future<void> _onFetchMember(
    FetchTeamMemberEvent event,
    Emitter<TeamMemberState> emit,
  ) async {
    try {
      await _repository.getTeamMember(event.teamId).then((value) async {
        if (value.statusCode == 200) {
          ResponseList<MemberData> responseList =
              ResponseList.fromJson(value.data, MemberData.fromJson);
          emit(TeamMemberSuccess(memberDatas: responseList.data!));
        } else if (value.statusCode == 404) {
          NavigatorService.showSnackBarAndGoBack('error_404'.tr());
        } else {
          emit(TeamMemberErrorState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(TeamMemberErrorState('error_no_internet'.tr()));
      } else {
        emit(TeamMemberErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onAddMember(
    AddMemberEvent event,
    Emitter<TeamMemberState> emit,
  ) async {
    try {
      var requestData = <String, dynamic>{
        'member_id': event.concactId,
        'leader_name': event.teamData.creatorName,
        'team_name': event.teamData.name,
      };
      await _repository
          .addMemberToTeam(event.teamData.id!, requestData: requestData)
          .then((value) async {
        if (value.statusCode == 200) {
          ResponseData<MemberData> responseData =
              ResponseData.fromJson(value.data, MemberData.fromJson);
          if (state is TeamMemberSuccess) {
            final successState = state as TeamMemberSuccess;
            emit(successState.copyWith(teamData: event.teamData, memberDatas: [
              responseData.data!,
              ...successState.memberDatas
            ]));
          }
        } else if (value.statusCode == 409) {
          emit(TeamMemberErrorState('error_409_already_exist_member'.tr()));
        } else {
          emit(TeamMemberErrorState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(TeamMemberErrorState('error_no_internet'.tr()));
      } else {
        emit(TeamMemberErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onRemoveMember(
    RemoveMemberEvent event,
    Emitter<TeamMemberState> emit,
  ) async {
    try {
      var requestData = <String, dynamic>{
        'member_id': event.teamMemberId,
        'leader_name': event.teamData.creatorName,
        'team_name': event.teamData.name,
      };
      await _repository
          .removeMember(event.teamData.id!, event.teamMemberId,
              requestData: requestData)
          .then((value) async {
        if (value.statusCode == 200) {
          if (state is TeamMemberSuccess) {
            final successState = state as TeamMemberSuccess;
            final listMemberNew = List.of(successState.memberDatas)
              ..removeWhere(
                (element) => element.id == event.teamMemberId,
              );
            emit(successState.copyWith(memberDatas: listMemberNew));
          }
        } else {
          emit(TeamMemberErrorState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(TeamMemberErrorState('error_no_internet'.tr()));
      } else {
        emit(TeamMemberErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onSearchMember(
    SearchMemberEvent event,
    Emitter<TeamMemberState> emit,
  ) async {
    try {
      var queryParam = <String, dynamic>{
        'keyword': event.keyword,
      };
      await _repository
          .searchTeamMember(event.teamId, queryParam: queryParam)
          .then((value) async {
        if (value.statusCode == 200) {
          ResponseList<MemberData> responseList =
              ResponseList.fromJson(value.data, MemberData.fromJson);
          emit(TeamMemberSuccess(memberDatas: responseList.data!));
        } else {
          emit(TeamMemberErrorState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(TeamMemberErrorState('error_no_internet'.tr()));
      } else {
        emit(TeamMemberErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onSearchOff(
    SearchMemberOffEvent event,
    Emitter<TeamMemberState> emit,
  ) async {
    add(FetchTeamMemberEvent(teamId: event.teamId));
  }
}

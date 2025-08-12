import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
import 'package:taskflow/src/views/create_team_dialog/bloc/create_team_event.dart';
import 'package:taskflow/src/views/create_team_dialog/bloc/create_team_state.dart';

class CreateTeamBloc extends Bloc<CreateTeamEvent, CreateTeamState> {
  CreateTeamBloc(super.initialState) {
    on<AddMemberEvent>(_onAddMember);
    on<RemoveMemberEvent>(_onRemoveMember);
    on<CreateEvent>(_onCreate);
  }

  final _repository = Repository();

  Future<void> _onAddMember(
    AddMemberEvent event,
    Emitter<CreateTeamState> emit,
  ) async {
    emit(
      state.copyWith(
        contactDatas: List.from(state.contactDatas)..add(event.contactData),
      ),
    );
  }

  Future<void> _onRemoveMember(
    RemoveMemberEvent event,
    Emitter<CreateTeamState> emit,
  ) async {
    int indexOf = state.contactDatas.indexWhere((e) => e.id == event.id);
    if (indexOf >= 0) {
      emit(state.copyWith(
          contactDatas: List.from(state.contactDatas)..removeAt(indexOf)));
    }
  }

  Future<void> _onCreate(
    CreateEvent event,
    Emitter<CreateTeamState> emit,
  ) async {
    try {
      var requestData = <String, dynamic>{
        'name': event.name,
      };
      await _repository
          .createTeam(requestData: requestData)
          .then((value) async {
        if (value.statusCode == 200) {
          NavigatorService.goBack(signals: true);
        } else {
          NavigatorService.goBack(signals: false);
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        NavigatorService.showSnackBar('error_no_internet'.tr());
      } else {
        NavigatorService.showSnackBar('lbl_error'.tr());
      }
    }
  }
}

import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/team/team_data.dart';

class TeamEvent {}

class FetchTeamEvent extends TeamEvent {}

class FetchTeamMemberEvent extends TeamEvent {}

class CreateTeamMemberEvent extends TeamEvent {}

class DisplayDetailTeam extends TeamEvent {}

class AddMemberEvent extends TeamEvent {
  final ContactData contactData;
  final TeamData teamData;
  AddMemberEvent({required this.contactData, required this.teamData});
}

class UpdateTeamEvent extends TeamEvent {
  final String teamId;
  final String newName;
  UpdateTeamEvent({required this.teamId, required this.newName});
}

class LeaveTeamEvent extends TeamEvent {
  final TeamData teamData;
  LeaveTeamEvent({required this.teamData});
}

class SearchTeamEvent extends TeamEvent {
  final String keySearch;
  SearchTeamEvent({required this.keySearch});
}

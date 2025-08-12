import 'package:taskflow/src/data/model/team/team_data.dart';

class TeamMemberEvent {}

class TeamMemberInitialEvent extends TeamMemberEvent {}

class FetchTeamMemberEvent extends TeamMemberEvent {
  final String teamId;
  FetchTeamMemberEvent({required this.teamId});
}

class RemoveMemberEvent extends TeamMemberEvent {
  final TeamData teamData;
  final String teamMemberId;
  RemoveMemberEvent({required this.teamData, required this.teamMemberId});
}

class AddMemberEvent extends TeamMemberEvent {
  final TeamData teamData;
  final String concactId;
  AddMemberEvent({required this.teamData, required this.concactId});
}

class SearchMemberEvent extends TeamMemberEvent {
  final String teamId;
  final String keyword;
  SearchMemberEvent({required this.teamId, required this.keyword});
}

class SearchMemberOffEvent extends TeamMemberEvent {
  final String teamId;
  SearchMemberOffEvent({required this.teamId});
}

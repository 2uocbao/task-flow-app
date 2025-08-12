import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/team/team_data.dart';
import 'package:taskflow/src/data/model/team_member/member_data.dart';

class TeamState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchDataLoading extends TeamState {}

class TeamErrorState extends TeamState {
  final String error;
  TeamErrorState(this.error);
}

class TeamSuccessState extends TeamState {
  final String message;
  TeamSuccessState(this.message);
}

class FetchDataSuccess extends TeamState {
  final List<TeamData> teamData;
  final List<MemberData> memberData;
  final List<TeamData> teamSearchResult;

  FetchDataSuccess({
    this.teamData = const [],
    this.memberData = const [],
    this.teamSearchResult = const [],
  });

  FetchDataSuccess copyWith({
    List<TeamData>? teamData,
    List<MemberData>? memberData,
    List<TeamData>? teamSearchResult,
  }) {
    return FetchDataSuccess(
      teamData: teamData ?? this.teamData,
      memberData: memberData ?? this.memberData,
      teamSearchResult: teamSearchResult ?? this.teamSearchResult,
    );
  }

  @override
  List<Object?> get props => [
        teamData,
        memberData,
        teamSearchResult,
      ];
}

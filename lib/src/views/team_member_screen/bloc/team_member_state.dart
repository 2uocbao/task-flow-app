import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/team/team_data.dart';
import 'package:taskflow/src/data/model/team_member/member_data.dart';

class TeamMemberState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamMemberErrorState extends TeamMemberState {
  final String error;
  TeamMemberErrorState(this.error);
}

class TeamMemberSuccess extends TeamMemberState {
  final List<MemberData> memberDatas;

  TeamMemberSuccess({this.memberDatas = const []});

  TeamMemberSuccess copyWith({
    List<MemberData>? memberDatas,
    TeamData? teamData,
  }) {
    return TeamMemberSuccess(
      memberDatas: memberDatas ?? this.memberDatas,
    );
  }

  @override
  List<Object?> get props => [memberDatas];
}

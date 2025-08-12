import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/contact/contact_data.dart';

class CreateTeamState extends Equatable {
  final List<ContactData> contactDatas;
  const CreateTeamState({this.contactDatas = const []});

  CreateTeamState copyWith({
    List<ContactData>? contactDatas,
  }) {
    return CreateTeamState(
      contactDatas: contactDatas ?? this.contactDatas,
    );
  }

  @override
  List<Object?> get props => [contactDatas];
}

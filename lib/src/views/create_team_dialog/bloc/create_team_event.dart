import 'package:taskflow/src/data/model/contact/contact_data.dart';

class CreateTeamEvent {}

class AddMemberEvent extends CreateTeamEvent {
  final ContactData contactData;
  AddMemberEvent(this.contactData);
}

class RemoveMemberEvent extends CreateTeamEvent {
  final String id;
  RemoveMemberEvent(this.id);
}

class CreateEvent extends CreateTeamEvent {
  final String name;
  CreateEvent(this.name);
}

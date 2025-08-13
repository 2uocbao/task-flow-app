import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/contact/contact_data.dart';

class ContactEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchContactEvent extends ContactEvent {}

class ReloadContactEvent extends ContactEvent {}
class SearchContactEvent extends ContactEvent {
  final String keySearch;
  SearchContactEvent(this.keySearch);
}

class SearchUserEvent extends ContactEvent {
  final String keySearch;
  SearchUserEvent(this.keySearch);
}

class ChangeOptionEvent extends ContactEvent {
  final String options;
  ChangeOptionEvent(this.options);
}

class SendRequestEvent extends ContactEvent {
  final String toUserId;
  SendRequestEvent(this.toUserId);
}

class AcceptRequestEvent extends ContactEvent {
  final ContactData contactData;
  AcceptRequestEvent(this.contactData);
}

class DenyRequestEvent extends ContactEvent {
  final String id;
  DenyRequestEvent(this.id);
}

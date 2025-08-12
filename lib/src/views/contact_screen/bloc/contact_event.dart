import 'package:equatable/equatable.dart';
<<<<<<< HEAD
import 'package:taskflow/src/data/model/contact/contact_data.dart';
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

class ContactEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchContactEvent extends ContactEvent {}

<<<<<<< HEAD
class ReloadContactEvent extends ContactEvent {}

=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
<<<<<<< HEAD
  final ContactData contactData;
  AcceptRequestEvent(this.contactData);
=======
  final String id;
  AcceptRequestEvent(this.id);
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}

class DenyRequestEvent extends ContactEvent {
  final String id;
  DenyRequestEvent(this.id);
}

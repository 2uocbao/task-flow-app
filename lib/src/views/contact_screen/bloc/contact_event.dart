import 'package:equatable/equatable.dart';

class ContactEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchContactEvent extends ContactEvent {}

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
  final String id;
  AcceptRequestEvent(this.id);
}

class DenyRequestEvent extends ContactEvent {
  final String id;
  DenyRequestEvent(this.id);
}

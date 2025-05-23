import 'package:equatable/equatable.dart';

class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitialEvent extends NotificationEvent {}

class FetchNotificationEvent extends NotificationEvent {}

class ChangeTypeNotificationEvent extends NotificationEvent {
  final String notifiType;

  ChangeTypeNotificationEvent(this.notifiType);

  @override
  List<Object?> get props => [notifiType];
}

class ChangeStatusNotificationEvent extends NotificationEvent {
  final bool notifiStatus;

  ChangeStatusNotificationEvent(this.notifiStatus);

  @override
  List<Object?> get props => [notifiStatus];
}

class AcceptContactEvent extends NotificationEvent {
  final int contactId;
  AcceptContactEvent(this.contactId);
}

class DenyContactEvent extends NotificationEvent {
  final int contactId;
  final String withUser;
  DenyContactEvent(this.contactId, this.withUser);
}

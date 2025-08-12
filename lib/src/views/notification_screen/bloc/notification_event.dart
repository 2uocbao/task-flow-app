<<<<<<< HEAD
import 'package:taskflow/src/data/model/notification/notification_data.dart';

class NotificationEvent {}
=======
import 'package:equatable/equatable.dart';

class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitialEvent extends NotificationEvent {}
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

class FetchNotificationEvent extends NotificationEvent {}

class ChangeTypeNotificationEvent extends NotificationEvent {
  final String notifiType;

  ChangeTypeNotificationEvent(this.notifiType);
<<<<<<< HEAD
=======

  @override
  List<Object?> get props => [notifiType];
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}

class ChangeStatusNotificationEvent extends NotificationEvent {
  final bool notifiStatus;

  ChangeStatusNotificationEvent(this.notifiStatus);
<<<<<<< HEAD
}

class AcceptContactEvent extends NotificationEvent {
  final NotificationData notificationData;
  AcceptContactEvent(this.notificationData);
=======

  @override
  List<Object?> get props => [notifiStatus];
}

class AcceptContactEvent extends NotificationEvent {
  final String contactId;
  AcceptContactEvent(this.contactId);
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}

class DenyContactEvent extends NotificationEvent {
  final String contactId;
  final String withUser;
  DenyContactEvent(this.contactId, this.withUser);
}

class UpdateStatusAllNotifi extends NotificationEvent {}

class UpdateStatusNotifi extends NotificationEvent {
  final String notifiId;
  UpdateStatusNotifi(this.notifiId);
}

class HaveNotifiUnReadEvent extends NotificationEvent {}

<<<<<<< HEAD
class HaveRequestEvent extends NotificationEvent {}

class NotificationCleared extends NotificationEvent {}
=======
class MaskNotificationReadEvent extends NotificationEvent {}

class HaveRequestEvent extends NotificationEvent {}
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

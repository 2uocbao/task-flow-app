import 'package:taskflow/src/data/model/notification/notification_data.dart';

class NotificationEvent {}

class FetchNotificationEvent extends NotificationEvent {}

class ChangeTypeNotificationEvent extends NotificationEvent {
  final String notifiType;

  ChangeTypeNotificationEvent(this.notifiType);
}

class ChangeStatusNotificationEvent extends NotificationEvent {
  final bool notifiStatus;

  ChangeStatusNotificationEvent(this.notifiStatus);
}

class AcceptContactEvent extends NotificationEvent {
  final NotificationData notificationData;
  AcceptContactEvent(this.notificationData);
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

class HaveRequestEvent extends NotificationEvent {}

class NotificationCleared extends NotificationEvent {}

import 'package:equatable/equatable.dart';
<<<<<<< HEAD
import 'package:taskflow/src/data/model/notification/notification_data.dart';

class NotificationState extends Equatable {
  final bool hasMore;
  final List<NotificationData> notificationData;

  const NotificationState(
      {this.hasMore = false, this.notificationData = const []});

  NotificationState copyWith({
    bool? hasMore,
    bool? hasUnRead,
    List<NotificationData>? notificationData,
  }) {
    return NotificationState(
      hasMore: hasMore ?? this.hasMore,
      notificationData: notificationData ?? this.notificationData,
=======
import 'package:taskflow/src/views/notification_screen/model/notification_model.dart';

// ignore: must_be_immutable
class NotificationState extends Equatable {
  bool hasMore;
  bool hasUnRead;
  NotificationModel notificationModel;

  NotificationState({
    required this.notificationModel,
    this.hasMore = false,
    this.hasUnRead = false,
  });

  NotificationState copyWith(
      {NotificationModel? notificationModel, bool? hasMore, bool? hasUnRead}) {
    return NotificationState(
      notificationModel: notificationModel ?? this.notificationModel,
      hasMore: hasMore ?? this.hasMore,
      hasUnRead: hasUnRead ?? this.hasUnRead,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    );
  }

  @override
<<<<<<< HEAD
  List<Object?> get props => [hasMore, notificationData];
}

class NotificationFailureState extends NotificationState {
  final String error;
  const NotificationFailureState(this.error);
}

class NotificationUpdated extends NotificationState {
  final bool hasNewNotification;
  const NotificationUpdated(this.hasNewNotification);
=======
  List<Object?> get props => [notificationModel, hasMore, hasUnRead];
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}

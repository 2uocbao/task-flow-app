import 'package:equatable/equatable.dart';
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
    );
  }

  @override
  List<Object?> get props => [hasMore, notificationData];
}

class NotificationFailureState extends NotificationState {
  final String error;
  const NotificationFailureState(this.error);
}

class NotificationUpdated extends NotificationState {
  final bool hasNewNotification;
  const NotificationUpdated(this.hasNewNotification);
}

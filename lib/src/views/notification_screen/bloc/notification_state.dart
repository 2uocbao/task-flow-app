import 'package:equatable/equatable.dart';
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
    );
  }

  @override
  List<Object?> get props => [notificationModel, hasMore, hasUnRead];
}

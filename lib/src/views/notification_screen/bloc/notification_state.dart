import 'package:equatable/equatable.dart';
import 'package:taskflow/src/views/notification_screen/model/notification_model.dart';

// ignore: must_be_immutable
class NotificationState extends Equatable {
  bool hasMore;
  NotificationModel notificationModel;

  NotificationState({required this.notificationModel, this.hasMore = false});

  NotificationState copyWith(
      {NotificationModel? notificationModel, bool? hasMore}) {
    return NotificationState(
      notificationModel: notificationModel ?? this.notificationModel,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [notificationModel, hasMore];
}

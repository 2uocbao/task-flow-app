import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/notification/notification_data.dart';

// ignore: must_be_immutable
class NotificationModel extends Equatable {
  String? selectedType;
  bool? selectedStatus;
  List<NotificationData> notificationData;

  NotificationModel(
      {this.selectedType = "ALL",
      this.selectedStatus = true,
      this.notificationData = const []});

  NotificationModel copyWith({
    String? selectedType,
    bool? selectedStatus,
    List<NotificationData>? notificationData,
  }) {
    return NotificationModel(
      selectedType: selectedType ?? this.selectedType,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      notificationData: notificationData ?? this.notificationData,
    );
  }

  @override
  List<Object?> get props => [selectedType, selectedStatus, notificationData];
}

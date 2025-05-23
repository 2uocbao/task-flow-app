import 'package:equatable/equatable.dart';

class CreateNewTaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateNewTaskInitialEvent extends CreateNewTaskEvent {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class ChangeDateEvent extends CreateNewTaskEvent {
  ChangeDateEvent({required this.date});
  DateTime date;

  @override
  List<Object?> get props => [date];
}

class CreateTaskEvent extends CreateNewTaskEvent {
  CreateTaskEvent();
  @override
  List<Object?> get props => [];
}

class ChangePriorityEvent extends CreateNewTaskEvent {
  final String priority;
  ChangePriorityEvent(this.priority);
}

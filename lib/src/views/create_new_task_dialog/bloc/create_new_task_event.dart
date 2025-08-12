<<<<<<< HEAD
class CreateNewTaskEvent {
  final String title;
  final String description;
  final String priority;
  final String dueAt;
  CreateNewTaskEvent(
      {required this.title,
      required this.description,
      required this.priority,
      required this.dueAt});
=======
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
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}

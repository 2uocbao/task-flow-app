<<<<<<< HEAD
class FilterTaskEvent {}

class FilterTaskInitialEvent extends FilterTaskEvent {}

class ChangeDateStartEvent extends FilterTaskEvent {
  final DateTime dateStart;
  ChangeDateStartEvent({required this.dateStart});
}

class ChangeDateEndEvent extends FilterTaskEvent {
  final DateTime dateEnd;
  ChangeDateEndEvent({required this.dateEnd});
}

class ChangePriorityEvent extends FilterTaskEvent {
  final String? priority;
  ChangePriorityEvent({required this.priority});
}

class ChangeTimeEvent extends FilterTaskEvent {
  final String? time;
  ChangeTimeEvent({required this.time});
=======
import 'package:equatable/equatable.dart';

class FilterTaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class FilterTaskInitialEvent extends FilterTaskEvent {}

// ignore: must_be_immutable
class ChangeDateStartEvent extends FilterTaskEvent {
  ChangeDateStartEvent({required this.dateStart});
  DateTime dateStart;

  @override
  List<Object?> get props => [dateStart];
}

// ignore: must_be_immutable
class ChangeDateEndEvent extends FilterTaskEvent {
  ChangeDateEndEvent({required this.dateEnd});
  DateTime dateEnd;

  @override
  List<Object?> get props => [dateEnd];
}

// ignore: must_be_immutable
class ChangeStatusEvent extends FilterTaskEvent {
  final String? status;

  ChangeStatusEvent({required this.status});

  @override
  List<Object?> get props => [status];
}

// ignore: must_be_immutable
class ChangePriorityEvent extends FilterTaskEvent {
  String? priority;

  ChangePriorityEvent({required this.priority});

  @override
  List<Object?> get props => [priority];
}

// ignore: must_be_immutable
class ChangeTimeEvent extends FilterTaskEvent {
  final String? time;

  ChangeTimeEvent({required this.time});

  @override
  List<Object?> get props => [time];
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}

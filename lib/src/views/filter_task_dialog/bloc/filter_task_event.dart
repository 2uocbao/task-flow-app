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
}

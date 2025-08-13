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
}

import 'package:equatable/equatable.dart';
<<<<<<< HEAD

class CreateNewTaskState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class CreateNewTaskSuccessState extends CreateNewTaskState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

=======
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CreateNewTaskState extends Equatable {
  CreateNewTaskState({
    this.taskNameInputController,
    this.taskDescriptionInputController,
    this.taskDueAtInputController,
    this.priority = 'LOW',
  });

  TextEditingController? taskNameInputController;
  TextEditingController? taskDescriptionInputController;
  TextEditingController? taskDueAtInputController;
  String? priority;

  @override
  List<Object?> get props => [
        taskNameInputController,
        taskDescriptionInputController,
        taskDueAtInputController,
        priority,
      ];
  CreateNewTaskState copyWith({
    TextEditingController? taskNameInputController,
    TextEditingController? taskDescriptionInputController,
    TextEditingController? taskDueAtInputController,
    String? priority,
  }) {
    return CreateNewTaskState(
      taskNameInputController:
          taskNameInputController ?? this.taskNameInputController,
      taskDescriptionInputController:
          taskDescriptionInputController ?? this.taskDescriptionInputController,
      taskDueAtInputController:
          taskDueAtInputController ?? this.taskDueAtInputController,
      priority: priority ?? this.priority,
    );
  }
}

// ignore: must_be_immutable
class CreateNewTaskSuccessState extends CreateNewTaskState {
  final bool isSuccess;

  CreateNewTaskSuccessState({required this.isSuccess});

  @override
  List<Object?> get props => [isSuccess];
}

// ignore: must_be_immutable
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
class CreateNewTaskErrorState extends CreateNewTaskState {
  final String error;

  CreateNewTaskErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

import 'package:equatable/equatable.dart';

class CreateNewTaskState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class CreateNewTaskSuccessState extends CreateNewTaskState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class CreateNewTaskErrorState extends CreateNewTaskState {
  final String error;

  CreateNewTaskErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

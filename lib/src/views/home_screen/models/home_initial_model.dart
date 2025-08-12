import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';

// ignore: must_be_immutable
class HomeInitialModel extends Equatable {
  HomeInitialModel({
    this.listTasks = const [],
    this.selectedType = 'MYTASK',
  });

  List<TaskData> listTasks;
  String selectedType;

  HomeInitialModel copyWith({List<TaskData>? listTasks, String? selectedType}) {
    return HomeInitialModel(
      listTasks: listTasks ?? this.listTasks,
      selectedType: selectedType ?? this.selectedType,
    );
  }

  @override
  List<Object?> get props => [listTasks, selectedType];
}

import 'package:equatable/equatable.dart';
import 'package:taskflow/src/views/filter_task_dialog/models/filter_task_model.dart';

// ignore: must_be_immutable
class FilterTaskState extends Equatable {
  const FilterTaskState({
    required this.filterTaskModel,
  });

  final FilterTaskModel filterTaskModel;

  @override
  List<Object?> get props => [
        filterTaskModel,
      ];
  FilterTaskState copyWith({
    FilterTaskModel? filterTaskModel,
  }) {
    return FilterTaskState(
      filterTaskModel: filterTaskModel ?? this.filterTaskModel,
    );
  }
}

import 'package:equatable/equatable.dart';
<<<<<<< HEAD

class FilterTaskState extends Equatable {
  final DateTime? selectedDateStart;

  final DateTime? selectedDateEnd;

  final String? selectedTime;

  final String? selectedPriority;
  const FilterTaskState({
    this.selectedDateStart,
    this.selectedDateEnd,
    this.selectedPriority,
    this.selectedTime,
  });

  FilterTaskState copyWith({
    DateTime? selectedDateStart,
    DateTime? selectedDateEnd,
    String? selectedPriority,
    String? selectedTime,
  }) {
    return FilterTaskState(
      selectedDateStart: selectedDateStart ?? this.selectedDateStart,
      selectedDateEnd: selectedDateEnd ?? this.selectedDateEnd,
      selectedPriority: selectedPriority ?? this.selectedPriority,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }

  @override
  List<Object?> get props =>
      [selectedDateStart, selectedDateEnd, selectedPriority, selectedTime];
=======
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
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}

import 'package:equatable/equatable.dart';

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
}

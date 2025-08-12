class FilterTaskModel {
  FilterTaskModel({
    this.selectedDateStart,
    this.selectedDateEnd,
    this.selectedStatus,
    this.selectedPriority,
    this.selectedTime,
  }) {
    selectedDateStart = selectedDateStart ?? DateTime.now();
    selectedDateEnd = selectedDateEnd ?? DateTime.now();
  }

  DateTime? selectedDateStart;

  DateTime? selectedDateEnd;

  String? selectedTime;

  String? selectedStatus;

  String? selectedPriority;

  FilterTaskModel copyWith({
    DateTime? selectedDateStart,
    DateTime? selectedDateEnd,
    String? selectedStatus,
    String? selectedPriority,
    String? selectedTime,
  }) {
    return FilterTaskModel(
      selectedDateStart: selectedDateStart ?? this.selectedDateStart,
      selectedDateEnd: selectedDateEnd ?? this.selectedDateEnd,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedPriority: selectedPriority ?? this.selectedPriority,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}

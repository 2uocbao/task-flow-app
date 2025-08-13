
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/views/filter_task_dialog/bloc/filter_task_event.dart';
import 'package:taskflow/src/views/filter_task_dialog/bloc/filter_task_state.dart';

class FilterTaskBloc extends Bloc<FilterTaskEvent, FilterTaskState> {
  FilterTaskBloc(super.initialState) {
    on<ChangeTimeEvent>(_onChangeTime);
    on<ChangePriorityEvent>(_onChangePriority);
    on<ChangeDateStartEvent>(_onSelectedDateStart);
    on<ChangeDateEndEvent>(_onSelectedDateEnd);
  }

  final logger = Logger();

  Future<void> _onChangeTime(
    ChangeTimeEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedTime: event.time,
      ),
    );
  }
  Future<void> _onChangePriority(
    ChangePriorityEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedPriority: event.priority,
      ),
    );
  }

  Future<void> _onSelectedDateStart(
    ChangeDateStartEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedDateStart: event.dateStart,
      ),
    );
  }

  Future<void> _onSelectedDateEnd(
    ChangeDateEndEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedDateEnd: event.dateEnd,
      ),
    );
  }
}

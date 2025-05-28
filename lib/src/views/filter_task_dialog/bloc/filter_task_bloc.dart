import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/views/filter_task_dialog/bloc/filter_task_event.dart';
import 'package:taskflow/src/views/filter_task_dialog/bloc/filter_task_state.dart';

class FilterTaskBloc extends Bloc<FilterTaskEvent, FilterTaskState> {
  FilterTaskBloc(super.initialState) {
    on<FilterTaskInitialEvent>(_initialState);
    on<ChangeTimeEvent>(_onChangeTime);
    on<ChangeStatusEvent>(_onChangeStatus);
    on<ChangePriorityEvent>(_onChangePriority);
    on<ChangeDateStartEvent>(_onSelectedDateStart);
    on<ChangeDateEndEvent>(_onSelectedDateEnd);
  }

  final logger = Logger();

  _initialState(
    FilterTaskInitialEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        filterTaskModel: state.filterTaskModel.copyWith(
          selectedPriority: "bt_high".tr(),
          selectedTime: "TODAY".tr(),
          selectedStatus: "PENDING".tr(),
        ),
      ),
    );
  }

  _onChangeTime(
    ChangeTimeEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        filterTaskModel: state.filterTaskModel.copyWith(
          selectedTime: event.time,
        ),
      ),
    );
  }

  _onChangeStatus(
    ChangeStatusEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        filterTaskModel: state.filterTaskModel.copyWith(
          selectedStatus: event.status,
        ),
      ),
    );
  }

  _onChangePriority(
    ChangePriorityEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        filterTaskModel: state.filterTaskModel.copyWith(
          selectedPriority: event.priority,
        ),
      ),
    );
  }

  _onSelectedDateStart(
    ChangeDateStartEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        filterTaskModel: state.filterTaskModel.copyWith(
          selectedDateStart: event.dateStart,
        ),
      ),
    );
  }

  _onSelectedDateEnd(
    ChangeDateEndEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        filterTaskModel: state.filterTaskModel.copyWith(
          selectedDateEnd: event.dateEnd,
        ),
      ),
    );
  }
}

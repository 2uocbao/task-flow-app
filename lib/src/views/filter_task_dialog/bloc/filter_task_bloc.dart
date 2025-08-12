<<<<<<< HEAD
=======
import 'package:easy_localization/easy_localization.dart';
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/views/filter_task_dialog/bloc/filter_task_event.dart';
import 'package:taskflow/src/views/filter_task_dialog/bloc/filter_task_state.dart';

class FilterTaskBloc extends Bloc<FilterTaskEvent, FilterTaskState> {
  FilterTaskBloc(super.initialState) {
<<<<<<< HEAD
    on<ChangeTimeEvent>(_onChangeTime);
=======
    on<FilterTaskInitialEvent>(_initialState);
    on<ChangeTimeEvent>(_onChangeTime);
    on<ChangeStatusEvent>(_onChangeStatus);
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    on<ChangePriorityEvent>(_onChangePriority);
    on<ChangeDateStartEvent>(_onSelectedDateStart);
    on<ChangeDateEndEvent>(_onSelectedDateEnd);
  }

  final logger = Logger();

<<<<<<< HEAD
  Future<void> _onChangeTime(
=======
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
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    ChangeTimeEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
<<<<<<< HEAD
        selectedTime: event.time,
=======
        filterTaskModel: state.filterTaskModel.copyWith(
          selectedTime: event.time,
        ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      ),
    );
  }

<<<<<<< HEAD
  Future<void> _onChangePriority(
=======
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
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    ChangePriorityEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
<<<<<<< HEAD
        selectedPriority: event.priority,
=======
        filterTaskModel: state.filterTaskModel.copyWith(
          selectedPriority: event.priority,
        ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      ),
    );
  }

<<<<<<< HEAD
  Future<void> _onSelectedDateStart(
=======
  _onSelectedDateStart(
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    ChangeDateStartEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
<<<<<<< HEAD
        selectedDateStart: event.dateStart,
=======
        filterTaskModel: state.filterTaskModel.copyWith(
          selectedDateStart: event.dateStart,
        ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      ),
    );
  }

<<<<<<< HEAD
  Future<void> _onSelectedDateEnd(
=======
  _onSelectedDateEnd(
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    ChangeDateEndEvent event,
    Emitter<FilterTaskState> emit,
  ) async {
    emit(
      state.copyWith(
<<<<<<< HEAD
        selectedDateEnd: event.dateEnd,
=======
        filterTaskModel: state.filterTaskModel.copyWith(
          selectedDateEnd: event.dateEnd,
        ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/model/notification/notification_data.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
import 'package:taskflow/src/views/notification_screen/bloc/notification_event.dart';
import 'package:taskflow/src/views/notification_screen/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(super.initialState) {
    on<ChangeTypeNotificationEvent>(_onChangeType);
    on<ChangeStatusNotificationEvent>(_onChangeStatus);
    on<FetchNotificationEvent>(_onFetchNotification);
    on<AcceptContactEvent>(_onAcceptContact);
    on<DenyContactEvent>(_onDenyContact);
    on<UpdateStatusAllNotifi>(_onUpdateStatusAll);
    on<UpdateStatusNotifi>(_onUpdateStatus);
    on<HaveNotifiUnReadEvent>(_onExistUnReadNotifi);
    on<NotificationCleared>(_onClearUnRead);
  }

  int currentPage = 0;
  final _repository = Repository();

  bool _hasNew = false;

  Future<void> _onChangeType(
    ChangeTypeNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (event.notifiType != PrefUtils().getTypeNotifi()) {
      currentPage = 0;
      emit(
        state.copyWith(
          notificationData: [],
          hasMore: false,
        ),
      );
      PrefUtils().setTypeNotifi(event.notifiType);
      add(FetchNotificationEvent());
    }
  }

  Future<void> _onChangeStatus(
    ChangeStatusNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    currentPage = 0;
    emit(
      state.copyWith(
        notificationData: [],
        hasMore: false,
      ),
    );
    PrefUtils().setReadNotifi(event.notifiStatus);
    add(FetchNotificationEvent());
  }

  Future<void> _onFetchNotification(
    FetchNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state.hasMore) {
        return;
      } else {
        Map<String, dynamic> requestParam = <String, dynamic>{
          'type': PrefUtils().getTypeNotifi(),
          'status': PrefUtils().getReadNotifi(),
          'size': 10,
          'page': currentPage,
        };
        await _repository.getNotification(queryParam: requestParam).then(
          (value) async {
            if (value.statusCode == 200) {
              ResponseList<NotificationData> responseList =
                  ResponseList.fromJson(value.data, NotificationData.fromJson);
              emit(
                state.copyWith(
                  hasMore: responseList.pagination!.currentPage! ==
                      responseList.pagination!.totalPages! - 1,
                  notificationData: [
                    ...state.notificationData,
                    ...responseList.data!
                  ],
                ),
              );
            } else {
              emit(NotificationFailureState('lbl_error'.tr()));
            }
          },
        );
        currentPage++;
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(NotificationFailureState('error_no_internet'.tr()));
      } else {
        emit(NotificationFailureState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onAcceptContact(
    AcceptContactEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      UserData userData = PrefUtils().getUser()!;
      final requestData = <String, dynamic>{
        'sender_name': userData.firstName! + userData.lastName!,
        'to_user': event.notificationData.senderId,
        'status': 'ACCEPTED',
      };
      await _repository
          .updateContact(event.notificationData.contentId!,
              requestData: requestData)
          .then((onValue) async {
        if (onValue.statusCode == 200) {
          final updateNotifi = List.of(state.notificationData)
            ..removeWhere((notifi) =>
                notifi.contentId == event.notificationData.contentId);
          emit(state.copyWith(notificationData: updateNotifi));
        } else {
          emit(NotificationFailureState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(NotificationFailureState('error_no_internet'.tr()));
      } else {
        emit(NotificationFailureState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onDenyContact(
    DenyContactEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.deleteContact(event.contactId).then((onValue) async {
        if (onValue.statusCode == 200) {
          final updateNotifi = List.of(state.notificationData)
            ..removeWhere((notifi) => notifi.contentId == event.contactId);
          emit(state.copyWith(notificationData: updateNotifi));
        } else {
          emit(NotificationFailureState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(NotificationFailureState('error_no_internet'.tr()));
      } else {
        emit(NotificationFailureState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onUpdateStatusAll(
    UpdateStatusAllNotifi event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.updateAllNotiStatus().then((value) {
        if (value.statusCode == 200) {
          final updateNotifi = state.notificationData.map((notifi) {
            return notifi.copyWith(status: true);
          }).toList();
          emit(state.copyWith(notificationData: updateNotifi));
        } else {
          emit(NotificationFailureState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(NotificationFailureState('error_no_internet'.tr()));
      } else {
        emit(NotificationFailureState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onUpdateStatus(
    UpdateStatusNotifi event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.updateStatusNotifi(event.notifiId).then((value) {
        if (value.statusCode == 200) {
          final updateNotifi = state.notificationData.map((notifi) {
            if (notifi.id == event.notifiId) {
              return notifi.copyWith(status: true);
            }
            return notifi;
          }).toList();
          emit(state.copyWith(notificationData: updateNotifi));
        } else {
          emit(NotificationFailureState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(NotificationFailureState('error_no_internet'.tr()));
      } else {
        emit(NotificationFailureState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onExistUnReadNotifi(
    HaveNotifiUnReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository.haveUnRead().then((value) async {
      if (value.statusCode == 200) {
        _hasNew = value.data['data'];
        emit(NotificationUpdated(_hasNew));
      } else {
        emit(NotificationUpdated(_hasNew));
      }
    });
  }

  Future<void> _onClearUnRead(
    NotificationCleared event,
    Emitter<NotificationState> emit,
  ) async {
    _hasNew = false;
    emit(NotificationUpdated(_hasNew));
  }
}

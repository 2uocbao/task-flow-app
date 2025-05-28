import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/model/notification/notification_data.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/repository/repository.dart';
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
  }

  int currentPage = 0;
  final _repository = Repository();

  _onChangeType(
    ChangeTypeNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (event.notifiType != PrefUtils().getTypeNotifi()) {
      currentPage = 0;
      emit(
        state.copyWith(
          notificationModel: state.notificationModel.copyWith(
            notificationData: [],
            selectedType: event.notifiType,
          ),
          hasMore: false,
        ),
      );
      PrefUtils().setTypeNotifi(event.notifiType);
      add(FetchNotificationEvent());
    }
  }

  _onChangeStatus(
    ChangeStatusNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    currentPage = 0;
    emit(
      state.copyWith(
        notificationModel: state.notificationModel.copyWith(
          selectedStatus: event.notifiStatus,
          notificationData: [],
        ),
        hasMore: false,
      ),
    );
    PrefUtils().setReadNotifi(event.notifiStatus);
    add(FetchNotificationEvent());
  }

  _onFetchNotification(
    FetchNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (state.hasMore) {
      return;
    } else {
      Map<String, dynamic> requestParam = <String, dynamic>{
        'type': PrefUtils().getTypeNotifi(),
        'status': PrefUtils().getReadNotifi(),
        'size': 10,
        'page': currentPage,
      };
      await _repository
          .getNotification(PrefUtils().getUser()!.id!, queryParam: requestParam)
          .then(
        (value) async {
          if (value.statusCode == 200) {
            ResponseList<NotificationData> responseList =
                ResponseList.fromJson(value.data, NotificationData.fromJson);
            emit(
              state.copyWith(
                notificationModel: state.notificationModel.copyWith(
                  notificationData: [
                    ...state.notificationModel.notificationData,
                    ...responseList.data!
                  ],
                ),
                hasMore: responseList.pagination!.currentPage! ==
                    responseList.pagination!.totalPages! - 1,
              ),
            );
          }
        },
      );
      currentPage++;
    }
  }

  _onAcceptContact(
    AcceptContactEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final requestData = <String, dynamic>{
      'status': 'ACCEPTED',
    };
    await _repository
        .updateContact(PrefUtils().getUser()!.id!, event.contactId,
            requestData: requestData)
        .then((onValue) async {
      if (onValue.statusCode == 200) {
        final updateNotifi =
            state.notificationModel.notificationData.map((notifi) {
          if (notifi.contentId == event.contactId) {
            return notifi.copyWith(type: 'CONTACTACEPT', status: true);
          }
          return notifi;
        }).toList();

        emit(state.copyWith(
            notificationModel: state.notificationModel.copyWith(
          notificationData: updateNotifi,
        )));
      } else {
        NavigatorService.showErrorAndGoBack("lbl_error".tr());
      }
    });
  }

  _onDenyContact(
    DenyContactEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository
        .deleteContact(PrefUtils().getUser()!.id!, event.contactId)
        .then((onValue) async {
      if (onValue.statusCode == 200) {
        final updateNotifi = state.notificationModel.notificationData;
        NotificationData notificationData = updateNotifi.firstWhere(
          (element) => element.contentId == event.contactId,
        );
        updateNotifi.remove(notificationData);
        emit(state.copyWith(
            notificationModel: state.notificationModel.copyWith(
          notificationData: updateNotifi,
        )));
      } else {
        NavigatorService.showErrorAndGoBack("lbl_error".tr());
      }
    });
  }

  _onUpdateStatusAll(
    UpdateStatusAllNotifi event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository
        .updateAllNotiStatus(PrefUtils().getUser()!.id!)
        .then((value) {
      if (value.statusCode == 200) {
        final updateNotifi =
            state.notificationModel.notificationData.map((notifi) {
          notifi.copyWith(status: true);
          return notifi;
        }).toList();
        emit(
          state.copyWith(
            notificationModel: state.notificationModel.copyWith(
              notificationData: updateNotifi,
            ),
          ),
        );
      }
    });
  }

  _onUpdateStatus(
    UpdateStatusNotifi event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository
        .updateStatusNotifi(PrefUtils().getUser()!.id!, event.notifiId)
        .then((value) {
      if (value.statusCode == 200) {
        final updateNotifi =
            state.notificationModel.notificationData.map((notifi) {
          if (notifi.id == event.notifiId) {
            return notifi.copyWith(status: true);
          }
          return notifi;
        }).toList();

        emit(
          state.copyWith(
            notificationModel: state.notificationModel.copyWith(
              notificationData: updateNotifi,
            ),
          ),
        );
      }
    });
  }

  _onExistUnReadNotifi(
    HaveNotifiUnReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository
        .haveUnRead(PrefUtils().getUser()!.id!)
        .then((value) async {
      if (value.statusCode == 200) {
        emit(
          state.copyWith(
            hasUnRead: value.data['data'],
          ),
        );
      }
    });
  }
}

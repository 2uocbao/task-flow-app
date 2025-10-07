import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
import 'package:taskflow/src/views/contact_screen/bloc/contact_event.dart';
import 'package:taskflow/src/views/contact_screen/bloc/contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc(super.initialState) {
    on<FetchContactEvent>(_onFetchContact);
    on<SearchContactEvent>(_onSearchContact);
    on<ChangeOptionEvent>(_onChangeOptions);
    on<SendRequestEvent>(_onSendRequest);
    on<AcceptRequestEvent>(_onAcceptRequest);
    on<DenyRequestEvent>(_onDenyRequest);
    on<SearchUserEvent>(_onSearchUser);
    on<ReloadContactEvent>(_onReloadEvent);
  }

  final _repository = Repository();
  int currentPage = 0;
  final logger = Logger();

  Future<void> _onChangeOptions(
    ChangeOptionEvent event,
    Emitter<ContactState> emit,
  ) async {
    PrefUtils().setOptionContact(event.options);
    emit(state.copyWith(
      currentOptions: event.options,
      hasMore: false,
      userResult: [],
      contactResult: [],
      contactData: [],
    ));
    currentPage = 0;
    add(FetchContactEvent());
  }

  Future<void> _onFetchContact(
    FetchContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    if (state.hasMore) {
      return;
    } else {
      final requestParam = <String, dynamic>{
        'status': PrefUtils().getOptionsContact(),
        'page': currentPage,
        'size': 10,
      };
      try {
        await _repository
            .getContacts(queryParam: requestParam)
            .then((value) async {
          if (value.statusCode == 200) {
            ResponseList<ContactData> responseList =
                ResponseList.fromJson(value.data, ContactData.fromJson);
            emit(
              state.copyWith(
                contactData: [...state.contactData, ...responseList.data!],
                hasMore: responseList.pagination!.currentPage! ==
                    responseList.pagination!.totalPages! - 1,
              ),
            );
          } else {
            emit(FetchContactFailure('lbl_error'.tr()));
          }
        });
        currentPage++;
      } catch (e) {
        if (e is NoInternetException) {
          emit(FetchContactFailure('error_no_internet'.tr()));
        } else {
          emit(FetchContactFailure('lbl_error'.tr()));
        }
      }
    }
  }

  Future<void> _onSearchContact(
    SearchContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    try {
      final requestParam = <String, dynamic>{
        'keyword': event.keySearch,
        'status': PrefUtils().getOptionsContact(),
        'size': 10,
      };
      await _repository
          .searchContact(queryParam: requestParam)
          .then((onValue) async {
        emit(state.copyWith(contactResult: []));
        ResponseList<ContactData> responseList =
            ResponseList.fromJson(onValue.data, ContactData.fromJson);
        emit(state.copyWith(contactResult: responseList.data));
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(FetchContactFailure('error_no_internet'.tr()));
      } else {
        emit(FetchContactFailure('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onSearchUser(
    SearchUserEvent event,
    Emitter<ContactState> emit,
  ) async {
    try {
      final requestParam = <String, dynamic>{
        'keyword': event.keySearch,
        'size': 10,
      };
      emit(state.copyWith(userResult: []));
      await _repository
          .searchUser(queryParam: requestParam)
          .then((value) async {
        ResponseList<UserData> responseList =
            ResponseList.fromJson(value.data, UserData.fromJson);
        emit(state.copyWith(userResult: responseList.data));
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(FetchContactFailure('error_no_internet'.tr()));
      } else {
        emit(FetchContactFailure('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onSendRequest(
    SendRequestEvent event,
    Emitter<ContactState> emit,
  ) async {
    var requestData = <String, dynamic>{
      'to_user': event.toUserId,
    };
    try {
      await _repository.addContact(requestData: requestData).then((value) {
        if (value.statusCode == 200) {
          final userResultAfter = List.of(state.userResult)
            ..removeWhere((user) => user.id == event.toUserId);
          emit(
            state.copyWith(
              userResult: userResultAfter,
            ),
          );
        } else {
          emit(FetchContactFailure('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(FetchContactFailure('error_no_internet'.tr()));
      } else {
        emit(FetchContactFailure('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onAcceptRequest(
    AcceptRequestEvent event,
    Emitter<ContactState> emit,
  ) async {
    final requestData = <String, dynamic>{
      'status': 'ACCEPTED',
    };
    try {
      await _repository
          .updateContact(event.contactData.id!, requestData: requestData)
          .then((onValue) async {
        if (onValue.statusCode == 200) {
          final updateList = List.of(state.contactData)
            ..removeWhere((contact) => contact.id == event.contactData.id);
          emit(
            state.copyWith(
              contactData: updateList,
            ),
          );
          add(FetchContactEvent());
        } else {
          emit(FetchContactFailure('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(FetchContactFailure('error_no_internet'.tr()));
      } else {
        emit(FetchContactFailure('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onDenyRequest(
    DenyRequestEvent event,
    Emitter<ContactState> emit,
  ) async {
    try {
      await _repository.deleteContact(event.id).then((onValue) async {
        if (onValue.statusCode == 200) {
          final updateListAfter = List.of(state.contactData)
            ..removeWhere((contact) => contact.id == event.id);
          emit(
            state.copyWith(
              contactData: updateListAfter,
            ),
          );
        } else {
          emit(FetchContactFailure('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(FetchContactFailure('error_no_internet'.tr()));
      } else {
        emit(FetchContactFailure('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onReloadEvent(
    ReloadContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    emit(state.copyWith(hasMore: false, contactData: []));
    currentPage = 0;
    try {
      final requestParam = <String, dynamic>{
        'status': PrefUtils().getOptionsContact(),
        'page': currentPage,
        'size': 10,
      };
      await _repository
          .getContacts(queryParam: requestParam)
          .then((value) async {
        if (value.statusCode == 200) {
          ResponseList<ContactData> responseList =
              ResponseList.fromJson(value.data, ContactData.fromJson);
          emit(
            state.copyWith(
              contactData: [...state.contactData, ...responseList.data!],
              hasMore: responseList.pagination!.currentPage! ==
                  responseList.pagination!.totalPages! - 1,
            ),
          );
        } else {
          emit(FetchContactFailure('lbl_error'.tr()));
        }
      });
      currentPage++;
    } catch (e) {
      if (e is NoInternetException) {
        emit(FetchContactFailure('error_no_internet'.tr()));
      } else {
        emit(FetchContactFailure('lbl_error'.tr()));
      }
    }
  }
}

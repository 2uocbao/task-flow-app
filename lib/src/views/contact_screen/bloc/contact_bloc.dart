import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/app_export.dart';
<<<<<<< HEAD
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
<<<<<<< HEAD
    on<ReloadContactEvent>(_onReloadEvent);
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

  final _repository = Repository();
  int currentPage = 0;
<<<<<<< HEAD
  final logger = Logger();

  Future<void> _onChangeOptions(
=======

  _onChangeOptions(
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    ChangeOptionEvent event,
    Emitter<ContactState> emit,
  ) async {
    PrefUtils().setOptionContact(event.options);
    emit(state.copyWith(
<<<<<<< HEAD
      currentOptions: event.options,
      hasMore: false,
      userResult: [],
      contactResult: [],
      contactData: [],
    ));
=======
        currentOptions: event.options,
        hasMore: false,
        userResult: [],
        contactResult: [],
        contactModel: state.contactModel.copyWith(contactData: [])));
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    currentPage = 0;
    add(FetchContactEvent());
  }

<<<<<<< HEAD
  Future<void> _onFetchContact(
=======
  _onFetchContact(
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
<<<<<<< HEAD
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
    UserData userData = PrefUtils().getUser()!;
    var requestData = <String, dynamic>{
      'sender_name': userData.firstName! + userData.lastName!,
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
    UserData userData = PrefUtils().getUser()!;
    final requestData = <String, dynamic>{
      'sender_name': userData.firstName! + userData.lastName!,
      'to_user': event.contactData.userId,
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
=======
      await _repository
          .getContacts(PrefUtils().getUser()!.id!, queryParam: requestParam)
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
          .then((value) async {
        if (value.statusCode == 200) {
          ResponseList<ContactData> responseList =
              ResponseList.fromJson(value.data, ContactData.fromJson);
          emit(
            state.copyWith(
<<<<<<< HEAD
              contactData: [...state.contactData, ...responseList.data!],
=======
              contactModel: state.contactModel.copyWith(
                contactData: [
                  ...state.contactModel.contactData,
                  ...responseList.data!
                ],
              ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
              hasMore: responseList.pagination!.currentPage! ==
                  responseList.pagination!.totalPages! - 1,
            ),
          );
<<<<<<< HEAD
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
=======
        }
      });
      currentPage++;
    }
  }

  _onSearchContact(
    SearchContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    final requestParam = <String, dynamic>{
      'keySearch': event.keySearch,
      'status': PrefUtils().getOptionsContact(),
      'size': 10,
    };
    await _repository
        .searchContact(PrefUtils().getUser()!.id!, queryParam: requestParam)
        .then((onValue) async {
      ResponseList<ContactData> responseList =
          ResponseList.fromJson(onValue.data, ContactData.fromJson);
      emit(state.copyWith(contactResult: responseList.data));
    });
  }

  _onSearchUser(
    SearchUserEvent event,
    Emitter<ContactState> emit,
  ) async {
    final requestParam = <String, dynamic>{
      'keySearch': event.keySearch,
      'size': 10,
    };
    await _repository
        .searchUser(PrefUtils().getUser()!.id!, queryParam: requestParam)
        .then((value) async {
      ResponseList<UserData> responseList =
          ResponseList.fromJson(value.data, UserData.fromJson);
      emit(state.copyWith(userResult: responseList.data));
    });
  }

  _onSendRequest(
    SendRequestEvent event,
    Emitter<ContactState> emit,
  ) async {
    ContactData contactData = ContactData();
    await _repository
        .addContact(
            requestData:
                contactData.toJson(PrefUtils().getUser()!.id!, event.toUserId))
        .then((value) {
      if (value.statusCode == 200) {
        final updateList = List<UserData>.from(state.userResult);
        final index =
            updateList.indexWhere((user) => user.id == event.toUserId);
        UserData userData = updateList.elementAt(index);
        if (index != -1) {
          updateList.remove(userData);
        }
        emit(
          state.copyWith(
            userResult: updateList,
          ),
        );
      } else {
        NavigatorService.showError("lbl_error".tr());
      }
    });
  }

  _onAcceptRequest(
    AcceptRequestEvent event,
    Emitter<ContactState> emit,
  ) async {
    final requestData = <String, dynamic>{
      'status': 'ACCEPTED',
    };
    await _repository
        .updateContact(PrefUtils().getUser()!.id!, event.id,
            requestData: requestData)
        .then((onValue) async {
      if (onValue.statusCode == 200) {
        final updateList =
            List<ContactData>.from(state.contactModel.contactData);
        final index =
            updateList.indexWhere((contact) => contact.id == event.id);
        ContactData contactData = updateList.elementAt(index);
        if (index != -1) {
          updateList.remove(contactData);
        }
        emit(
          state.copyWith(
            contactModel: state.contactModel.copyWith(
              contactData: updateList,
            ),
          ),
        );
      } else {
        NavigatorService.showError("lbl_error".tr());
      }
    });
  }

  _onDenyRequest(
    DenyRequestEvent event,
    Emitter<ContactState> emit,
  ) async {
    await _repository
        .deleteContact(PrefUtils().getUser()!.id!, event.id)
        .then((onValue) async {
      if (onValue.statusCode == 200) {
        final updateList =
            List<ContactData>.from(state.contactModel.contactData);
        final index =
            updateList.indexWhere((contact) => contact.id == event.id);
        ContactData contactData = updateList.elementAt(index);
        if (index != -1) {
          updateList.remove(contactData);
        }
        emit(
          state.copyWith(
            contactModel: state.contactModel.copyWith(
              contactData: updateList,
            ),
          ),
        );
      } else {
        NavigatorService.showError("lbl_error".tr());
      }
    });
  }
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}

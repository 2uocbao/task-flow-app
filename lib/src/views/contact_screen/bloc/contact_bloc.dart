import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/app_export.dart';
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
  }

  final _repository = Repository();
  int currentPage = 0;

  _onChangeOptions(
    ChangeOptionEvent event,
    Emitter<ContactState> emit,
  ) async {
    PrefUtils().setOptionContact(event.options);
    emit(state.copyWith(
        currentOptions: event.options,
        hasMore: false,
        userResult: [],
        contactModel: state.contactModel.copyWith(contactData: [])));
    currentPage = 0;
    add(FetchContactEvent());
  }

  _onFetchContact(
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
      await _repository
          .getContacts(PrefUtils().getUser()!.id!, queryParam: requestParam)
          .then((value) async {
        if (value.statusCode == 200) {
          ResponseList<ContactData> responseList =
              ResponseList.fromJson(value.data, ContactData.fromJson);
          emit(
            state.copyWith(
              contactModel: state.contactModel.copyWith(
                contactData: [
                  ...state.contactModel.contactData,
                  ...responseList.data!
                ],
              ),
              hasMore: responseList.pagination!.currentPage! ==
                  responseList.pagination!.totalPages! - 1,
            ),
          );
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
      }
    });
  }
}

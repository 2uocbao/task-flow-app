import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
<<<<<<< HEAD

class ContactState extends Equatable {
  final bool hasMore;
  final List<ContactData> contactData;
  final String currentOptions;
  final List<ContactData> contactResult;
  final List<UserData> userResult;

  const ContactState({
    this.contactData = const [],
=======
import 'package:taskflow/src/views/contact_screen/model/contact_model.dart';

// ignore: must_be_immutable
class ContactState extends Equatable {
  bool hasMore;
  final ContactModel contactModel;
  String currentOptions;
  List<ContactData> contactResult;
  List<UserData> userResult;

  ContactState({
    required this.contactModel,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    this.hasMore = false,
    this.currentOptions = 'Friends',
    this.contactResult = const [],
    this.userResult = const [],
  });

  ContactState copyWith({
<<<<<<< HEAD
    List<ContactData>? contactData,
=======
    ContactModel? contactModel,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    bool? hasMore,
    String? currentOptions,
    List<ContactData>? contactResult,
    List<UserData>? userResult,
  }) {
    return ContactState(
<<<<<<< HEAD
        contactData: contactData ?? this.contactData,
=======
        contactModel: contactModel ?? this.contactModel,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        currentOptions: currentOptions ?? this.currentOptions,
        contactResult: contactResult ?? this.contactResult,
        userResult: userResult ?? this.userResult,
        hasMore: hasMore ?? this.hasMore);
  }

  @override
  List<Object?> get props =>
<<<<<<< HEAD
      [contactData, hasMore, currentOptions, contactResult, userResult];
}

class FetchContactFailure extends ContactState {
  final String error;
  const FetchContactFailure(this.error);
=======
      [contactModel, hasMore, currentOptions, contactResult, userResult];
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}

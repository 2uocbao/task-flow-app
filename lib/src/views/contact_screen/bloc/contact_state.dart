import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
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
    this.hasMore = false,
    this.currentOptions = 'Friends',
    this.contactResult = const [],
    this.userResult = const [],
  });

  ContactState copyWith({
    ContactModel? contactModel,
    bool? hasMore,
    String? currentOptions,
    List<ContactData>? contactResult,
    List<UserData>? userResult,
  }) {
    return ContactState(
        contactModel: contactModel ?? this.contactModel,
        currentOptions: currentOptions ?? this.currentOptions,
        contactResult: contactResult ?? this.contactResult,
        userResult: userResult ?? this.userResult,
        hasMore: hasMore ?? this.hasMore);
  }

  @override
  List<Object?> get props =>
      [contactModel, hasMore, currentOptions, contactResult, userResult];
}

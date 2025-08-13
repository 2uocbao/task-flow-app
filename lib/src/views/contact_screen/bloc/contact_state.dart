import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';

class ContactState extends Equatable {
  final bool hasMore;
  final List<ContactData> contactData;
  final String currentOptions;
  final List<ContactData> contactResult;
  final List<UserData> userResult;

  const ContactState({
    this.contactData = const [],
    this.hasMore = false,
    this.currentOptions = 'Friends',
    this.contactResult = const [],
    this.userResult = const [],
  });

  ContactState copyWith({
    List<ContactData>? contactData,
    bool? hasMore,
    String? currentOptions,
    List<ContactData>? contactResult,
    List<UserData>? userResult,
  }) {
    return ContactState(
        contactData: contactData ?? this.contactData,
        currentOptions: currentOptions ?? this.currentOptions,
        contactResult: contactResult ?? this.contactResult,
        userResult: userResult ?? this.userResult,
        hasMore: hasMore ?? this.hasMore);
  }

  @override
  List<Object?> get props =>
      [contactData, hasMore, currentOptions, contactResult, userResult];
}

class FetchContactFailure extends ContactState {
  final String error;
  const FetchContactFailure(this.error);
}

import 'package:equatable/equatable.dart';
import 'package:taskflow/src/data/model/contact/contact_data.dart';

// ignore: must_be_immutable
class ContactModel extends Equatable {
  List<ContactData> contactData;

  ContactModel({
    this.contactData = const [],
  });

  ContactModel copyWith({
    List<ContactData>? contactData,
  }) {
    return ContactModel(contactData: contactData ?? this.contactData);
  }

  @override
  List<Object?> get props => [contactData];
}

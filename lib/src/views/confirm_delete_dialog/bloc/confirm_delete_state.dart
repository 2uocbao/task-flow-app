import 'package:equatable/equatable.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';

// ignore: must_be_immutable
class ConfirmDeleteState extends Equatable {
  CustomId? customId;
  ConfirmDeleteState({required this.customId});
  @override
  List<Object?> get props => [customId];
}

import 'package:equatable/equatable.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';

<<<<<<< HEAD
class ConfirmDeleteState extends Equatable {
  final CustomId? customId;
  const ConfirmDeleteState({required this.customId});
=======
// ignore: must_be_immutable
class ConfirmDeleteState extends Equatable {
  CustomId? customId;
  ConfirmDeleteState({required this.customId});
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  @override
  List<Object?> get props => [customId];
}

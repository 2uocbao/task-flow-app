import 'package:equatable/equatable.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';

class ConfirmDeleteState extends Equatable {
  final CustomId? customId;
  const ConfirmDeleteState({required this.customId});
  @override
  List<Object?> get props => [customId];
}

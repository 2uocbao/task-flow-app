import 'package:equatable/equatable.dart';

class ConfirmDeleteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestDeleteTaskEvent extends ConfirmDeleteEvent {}

class RequestDeleteCommentEvent extends ConfirmDeleteEvent {}

class RequestDeleteReportEvent extends ConfirmDeleteEvent {}

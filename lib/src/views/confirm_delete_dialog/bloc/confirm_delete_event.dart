<<<<<<< HEAD
class ConfirmDeleteEvent {}
=======
import 'package:equatable/equatable.dart';

class ConfirmDeleteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

class RequestDeleteTaskEvent extends ConfirmDeleteEvent {}

class RequestDeleteCommentEvent extends ConfirmDeleteEvent {}

class RequestDeleteReportEvent extends ConfirmDeleteEvent {}
<<<<<<< HEAD

class RequestDeleteMemberEvent extends ConfirmDeleteEvent {}

class RequestDeleteTeamEvent extends ConfirmDeleteEvent {}
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

<<<<<<< HEAD
class HomeEvent {}

class FetchDataEvent extends HomeEvent {}

class FetchTaskEvent extends HomeEvent {}

class LogoutEvent extends HomeEvent {}

class SelectedStatusEvent extends HomeEvent {
  final String status;
  SelectedStatusEvent({required this.status});
}

class SelectedTeamEvent extends HomeEvent {
  final String team;
  SelectedTeamEvent({required this.team});
=======
import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitialEvent extends HomeEvent {}

class FetchDataEvent extends HomeEvent {
  FetchDataEvent();
  @override
  List<Object?> get props => [];
}

class ChangeTypeEvent extends HomeEvent {
  final String type;

  ChangeTypeEvent({required this.type});
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}

class SearchTaskEvent extends HomeEvent {
  final String keySearch;
  SearchTaskEvent(this.keySearch);
}

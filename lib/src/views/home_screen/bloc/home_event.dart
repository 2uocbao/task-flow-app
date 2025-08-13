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
}

class SearchTaskEvent extends HomeEvent {
  final String keySearch;
  SearchTaskEvent(this.keySearch);
}

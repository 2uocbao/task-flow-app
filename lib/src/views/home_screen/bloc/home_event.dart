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
}

class SearchTaskEvent extends HomeEvent {
  final String keySearch;
  SearchTaskEvent(this.keySearch);
}

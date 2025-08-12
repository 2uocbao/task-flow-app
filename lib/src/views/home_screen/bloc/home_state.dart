import 'package:equatable/equatable.dart';
<<<<<<< HEAD
import 'package:taskflow/src/data/model/task/status_summary.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/data/model/team/team_data.dart';

class HomeState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class HomeLoadingState extends HomeState {}

class HomeFailureState extends HomeState {
  final String error;
  HomeFailureState(this.error);
}

class HomeNullDataState extends HomeState {}

class HomeFetchSuccessState extends HomeState {
  final bool hasMore;
  final bool isSuccess;
  final bool isLoading;
  final List<TeamData> listTeams;
  final List<StatusSummary> listStatusSummary;
  final List<TaskData> listTasks;
  final String selectedStatus;
  final String selectedTeam;
  final List<TaskData> resultSearch;

  HomeFetchSuccessState({
    this.isSuccess = false,
    this.isLoading = false,
    this.hasMore = false,
    this.listTeams = const [],
    this.listTasks = const [],
    this.listStatusSummary = const [],
    required this.selectedTeam,
    required this.selectedStatus,
    this.resultSearch = const [],
  });

  HomeFetchSuccessState copyWith({
    bool? isSuccess,
    bool? isLoading,
    bool? hasMore,
    List<TaskData>? resultSearch,
    List<TeamData>? listTeams,
    List<StatusSummary>? listStatusSummary,
    List<TaskData>? listTasks,
    String? selectedTeam,
    String? selectedStatus,
  }) {
    return HomeFetchSuccessState(
      isSuccess: isSuccess ?? this.isSuccess,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      resultSearch: resultSearch ?? this.resultSearch,
      listTeams: listTeams ?? this.listTeams,
      listStatusSummary: listStatusSummary ?? this.listStatusSummary,
      listTasks: listTasks ?? this.listTasks,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      selectedStatus: selectedStatus ?? this.selectedStatus,
=======
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/views/home_screen/models/home_initial_model.dart';

// ignore: must_be_immutable
class HomeState extends Equatable {
  bool hasMore;
  final HomeInitialModel homeInitialModel;
  List<TaskData> resultSearch;
  String selectedType;

  HomeState({
    this.hasMore = false,
    required this.homeInitialModel,
    this.selectedType = 'MYTASK',
    this.resultSearch = const [],
  });

  HomeState copyWith({
    bool? hasMore,
    HomeInitialModel? homeInitialModel,
    String? selectedType,
    List<TaskData>? resultSearch,
  }) {
    return HomeState(
      hasMore: hasMore ?? this.hasMore,
      homeInitialModel: homeInitialModel ?? this.homeInitialModel,
      selectedType: selectedType ?? this.selectedType,
      resultSearch: resultSearch ?? this.resultSearch,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    );
  }

  @override
<<<<<<< HEAD
  List<Object?> get props => [
        isSuccess,
        hasMore,
        isLoading,
        resultSearch,
        listTeams,
        listStatusSummary,
        listTasks,
        selectedStatus,
        selectedTeam
      ];
=======
  List<Object?> get props =>
      [homeInitialModel, hasMore, selectedType, resultSearch];
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}

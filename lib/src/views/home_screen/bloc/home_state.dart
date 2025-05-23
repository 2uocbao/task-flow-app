import 'package:equatable/equatable.dart';
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
    );
  }

  @override
  List<Object?> get props =>
      [homeInitialModel, hasMore, selectedType, resultSearch];
}

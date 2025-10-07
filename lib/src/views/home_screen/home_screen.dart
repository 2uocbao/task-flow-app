import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/task/status_summary.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/data/model/team/team_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/utils/progress_dialog_utils.dart';
import 'package:taskflow/src/views/create_new_task_dialog/create_new_task_dialog.dart';
import 'package:taskflow/src/views/filter_task_dialog/filter_task_dialog.dart';
import 'package:taskflow/src/views/home_screen/bloc/home_bloc.dart';
import 'package:taskflow/src/views/home_screen/bloc/home_event.dart';
import 'package:taskflow/src/views/home_screen/bloc/home_state.dart';
import 'package:taskflow/src/views/home_screen/widgets/custom_search_appbar.dart';
import 'package:taskflow/src/views/home_screen/widgets/task_item_widget.dart';
import 'package:taskflow/src/views/notification_screen/bloc/notification_bloc.dart';
import 'package:taskflow/src/views/notification_screen/bloc/notification_event.dart';
import 'package:taskflow/src/views/notification_screen/bloc/notification_state.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_arguments.dart';
import 'package:taskflow/src/utils/app_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static Widget builder(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(
            HomeState(),
          )..add(FetchDataEvent()),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(const NotificationState())
            ..add(HaveNotifiUnReadEvent()),
        )
      ],
      child: const HomeScreen(),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final logger = Logger();

  bool _showSearch = false;
  bool _isExpanded = false;
  bool _isFetching = false;

  bool get _isBottom {
    final successState =
        context.read<HomeBloc>().state as HomeFetchSuccessState;
    if (successState.hasMore) {
      return false;
    }
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll);
  }

  void _onScroll() {
    if (_isBottom && !_isFetching) {
      _isFetching = true;
      context.read<HomeBloc>().add(FetchTaskEvent());
      Future.delayed(const Duration(seconds: 1), () => _isFetching = false);
    }
    if (_isBottom) {
      context.read<HomeBloc>().add(FetchTaskEvent());
    }
  }

  void _onSearchTask(String keySearch) async {
    context.read<HomeBloc>().add(SearchTaskEvent(keySearch));
    setState(() {
      _textController.text = keySearch;
    });
  }

  void _resetWhenSearchOff() async {
    _textController.clear();
    _showSearch = false;
    context.read<HomeBloc>().add(FetchDataEvent());
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          if (_isExpanded) {
            _toggleFab();
          }
        },
        child: Scaffold(
          appBar: CustomSearchAppbar(
            showSearch: _showSearch,
            onToggleSearch: (value) => setState(() {
              _showSearch = value;
              _resetWhenSearchOff();
            }),
            onSearch: _onSearchTask,
            searchController: _textController,
            appbar: _buildAppBar(context),
          ),
          body: _buildBody(context),
          drawer: _openDrawer(context),
          floatingActionButton: _customFloatingActionButton(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadingState) {
          ProgressDialogUtils.showProgressDialog();
        } else if (state is HomeFailureState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.error),
              SizedBox(height: 5.h),
              CustomTextButton(
                text: 'bt_reload'.tr(),
                onPressed: () {
                  context.read<HomeBloc>().add(FetchDataEvent());
                },
              ),
            ],
          );
        } else if (state is HomeNullDataState) {
          return Center(
            child: Text('no_data_available'.tr()),
          );
        } else if (state is HomeFetchSuccessState) {
          return Column(
            children: [
              if (!_showSearch) ...{
                _showTeamsAndFilter(context, state),
                SizedBox(
                  height: 5.h,
                ),
                _buildViewStatus(context, state),
              },
              SizedBox(height: 5.h),
              Expanded(
                child: _showTaskList(context, state),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu, size: 30.sp),
          );
        },
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            setState(() {
              _showSearch = true;
            });
          },
          icon: Icon(Icons.search, size: 25.sp),
        ),
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            bool hasNew = false;
            if (state is NotificationUpdated) {
              hasNew = state.hasNewNotification;
            }
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<NotificationBloc>().add(NotificationCleared());
                    NavigatorService.pushNamed(AppRoutes.notificationScreen);
                  },
                  icon: Icon(Icons.notifications, size: 25.sp),
                ),
                if (hasNew)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.circle,
                      size: 10.sp,
                      color: Colors.red,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _showTaskList(BuildContext context, HomeFetchSuccessState state) {
    String timeNow = "TODAY".tr();
    bool has = false;
    List<Widget> customDisplay = [];
    List<TaskData> listTaskData = [];
    if (_showSearch) {
      listTaskData = state.resultSearch;
    } else {
      listTaskData = state.listTasks;
    }
    for (var taskData in listTaskData) {
      String stringTime = time(taskData.dueAt!);
      if (stringTime == timeNow) {
        if (!has) {
          customDisplay.add(
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
              child: Text(
                timeNow,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
          has = true;
        }
      } else {
        timeNow = stringTime;
        customDisplay.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
            child: Text(
              timeNow,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        );
        has = true;
      }
      customDisplay.add(
        TaskItemWidget(
          taskData,
          onTapToTask: () {
            NavigatorService.pushNamed(
              AppRoutes.taskDetailScreen,
              arguments: TaskDetailArguments(
                taskId: taskData.id,
              ),
            );
          },
        ),
      );
    }
    return ListView(
      controller: _scrollController,
      children: customDisplay,
    );
  }

  Widget _openDrawer(BuildContext context) {
    UserData? userData = PrefUtils().getUser();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCircleAvatar(imagePath: userData!.imagePath!, size: 50),
              Text('${userData.firstName!} ${userData.lastName}',
                  style: Theme.of(context).textTheme.titleSmall),
              Text(userData.email!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall),
            ],
          )),
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.settings,
                  size: 20.sp,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text('lbl_setting'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            onTap: () {
              NavigatorService.pushNamed(AppRoutes.settingScreen);
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.logout,
                  size: 20.sp,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text("lbl_logout".tr(),
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            onTap: () async {
              context.read<HomeBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
    );
  }

  Future<void> onTapCreateNewTask(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: CreateNewTaskDialog.builder(
          NavigatorService.navigatorKey.currentContext!,
        ),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
      ),
    );

    if (result == true) {
      // ignore: use_build_context_synchronously
      context.read<HomeBloc>().add(FetchDataEvent());
      NavigatorService.showSnackBar('lbl_create_task_success'.tr());
    } else {
      NavigatorService.showSnackBar('error_user_do_not_permission'.tr());
    }
  }

  void onTapOpenFilterTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FilterTaskDialog.builder(
            NavigatorService.navigatorKey.currentContext!,
          ),
        );
      },
    );
  }

  Widget _showTeamsAndFilter(
      BuildContext context, HomeFetchSuccessState state) {
    return SizedBox(
      height: 30.h,
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(child: _buildOptionSelectTeam(context, state.listTeams)),
          CustomIconButton(
            height: 30.h,
            width: 30.h,
            onTap: () {
              onTapOpenFilterTask(context);
            },
            child: Icon(Icons.filter_list_sharp, size: 30.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionSelectTeam(
      BuildContext context, List<TeamData> teamDatas) {
    List<Widget> customDisplay = [];
    String currentTeamId = PrefUtils().getTeamId();
    if (currentTeamId.isEmpty) {
      PrefUtils().setTeamId(teamDatas.first.id!);
      TeamData teamData = teamDatas.first;
      customDisplay.add(_buildCustomDisplayTeam(context, teamData));
    } else {
      int indexOfCurrentId =
          teamDatas.indexWhere((team) => team.id == currentTeamId);
      if (indexOfCurrentId > 0) {
        TeamData teamData = teamDatas.firstWhere(
          (element) => element.id == currentTeamId,
        );
        customDisplay.add(_buildCustomDisplayTeam(context, teamData));
      } else {
        PrefUtils().setTeamId(teamDatas.first.id!);
        TeamData teamData = teamDatas.first;
        customDisplay.add(_buildCustomDisplayTeam(context, teamData));
      }
    }
    for (TeamData team in teamDatas) {
      if (team.id != PrefUtils().getTeamId()) {
        customDisplay.add(_buildCustomDisplayTeam(context, team));
      }
    }
    return ListView(
      scrollDirection: Axis.horizontal,
      children: customDisplay,
    );
  }

  Widget _buildCustomDisplayTeam(BuildContext context, TeamData teamData) {
    return CustomTextButton(
      buttonStyle: ButtonStyle(
          backgroundColor: teamData.id == PrefUtils().getTeamId()
              ? const WidgetStatePropertyAll(Colors.blueGrey)
              : null),
      text: teamData.name!,
      margin: EdgeInsets.only(left: 5.w, right: 5.w),
      onPressed: () {
        context.read<HomeBloc>().add(SelectedTeamEvent(team: teamData.id!));
      },
    );
  }

  Widget _buildViewStatus(BuildContext context, HomeFetchSuccessState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatusModelView(
                context,
                'PENDING',
                Colors.grey.shade600,
                getQuantityOfTaskHaveStatus(
                    state.listStatusSummary, 'PENDING')),
            _buildStatusModelView(
                context,
                'IN_PROGRESS',
                Colors.blue.shade600,
                getQuantityOfTaskHaveStatus(
                    state.listStatusSummary, 'IN_PROGRESS')),
          ],
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatusModelView(
                context,
                'CANCELLED',
                Colors.orange.shade600,
                getQuantityOfTaskHaveStatus(
                    state.listStatusSummary, 'CANCELLED')),
            _buildStatusModelView(
                context,
                'COMPLETED',
                Colors.green.shade600,
                getQuantityOfTaskHaveStatus(
                    state.listStatusSummary, 'COMPLETED')),
          ],
        )
      ],
    );
  }

  int getQuantityOfTaskHaveStatus(
      List<StatusSummary> statusSummary, String status) {
    return statusSummary.indexWhere((element) => element.status == status, 0) !=
            -1
        ? (statusSummary
            .elementAt(statusSummary.indexWhere(
                (element) => element.status == status, 0))
            .quantity!)
        : 0;
  }

  Widget _buildStatusModelView(
      BuildContext context, String status, Color colors, int quantity) {
    return GestureDetector(
      onTap: () {
        context.read<HomeBloc>().add(SelectedStatusEvent(status: status));
      },
      child: Container(
        width: 140.w,
        height: 80.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusStyle.circleBorder5, color: colors),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 80.w,
                  margin: EdgeInsets.only(left: 10.w, top: 10.h),
                  child: Text(status.tr(),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall),
                ),
                const Spacer(),
                PrefUtils().getStatusFilterTask().contains(status)
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: Colors.red.shade400,
                      )
                    : const SizedBox(),
                SizedBox(
                  width: 5.w,
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Spacer(),
            Container(
              margin: EdgeInsets.only(left: 10.w, bottom: 10.h),
              child: Text(
                '$quantity tasks',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customFloatingActionButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isExpanded) ...[
          _customFloatingButton(context, 'lbl_teams'.tr(), Icons.group, () {
            _toggleFab();
            NavigatorService.pushNamed(AppRoutes.teamScreen);
          }),
          SizedBox(
            height: 10.h,
          ),
          _customFloatingButton(context, 'lbl_contacts'.tr(), Icons.person, () {
            _toggleFab();
            NavigatorService.pushNamed(AppRoutes.contactScreen);
          }),
          SizedBox(
            height: 10.h,
          ),
          _customFloatingButton(context, 'lbl_create_new_task'.tr(), Icons.add,
              () {
            _toggleFab();
            if (PrefUtils().getTeamId() != '') {
              onTapCreateNewTask(context);
            } else {
              NavigatorService.showSnackBar('team_not_found'.tr());
            }
          }),
          SizedBox(
            height: 10.h,
          ),
        ],
        FloatingActionButton(
          onPressed: () => setState(() => _isExpanded = !_isExpanded),
          child: Icon(_isExpanded ? Icons.close : Icons.menu),
        ),
      ],
    );
  }

  Widget _customFloatingButton(BuildContext context, String titleButton,
      IconData iconButton, Function() onTap) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadiusStyle.circleBorder10,
          color: Theme.of(context).colorScheme.onPrimary),
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(titleButton),
            SizedBox(
              width: 5.w,
            ),
            Icon(
              iconButton,
              size: 25.sp,
            ),
          ],
        ),
      ),
    );
  }
}

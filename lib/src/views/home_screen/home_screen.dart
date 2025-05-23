import 'package:easy_localization/easy_localization.dart';
import 'package:logger/logger.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/utils/token_storage.dart';
import 'package:taskflow/src/utils/utils.dart';
import 'package:taskflow/src/views/create_new_task_dialog/create_new_task_dialog.dart';
import 'package:taskflow/src/views/filter_task_dialog/filter_task_dialog.dart';
import 'package:taskflow/src/views/home_screen/bloc/home_bloc.dart';
import 'package:taskflow/src/views/home_screen/bloc/home_event.dart';
import 'package:taskflow/src/views/home_screen/bloc/home_state.dart';
import 'package:taskflow/src/views/home_screen/models/home_initial_model.dart';
import 'package:taskflow/src/views/home_screen/widgets/custom_search_appbar.dart';
import 'package:taskflow/src/views/home_screen/widgets/task_item_widget.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_arguments.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/widgets/custom_circle_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static Widget builder(BuildContext context) {
    return BlocProvider(
      child: const HomeScreen(),
      create: (context) => HomeBloc(
        HomeState(homeInitialModel: HomeInitialModel()),
      )..add(FetchDataEvent()),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  bool _showSearch = false;
  final TextEditingController _textController = TextEditingController();

  bool _isFetching = false;
  final logger = Logger();

  void _onScroll() {
    if (_isBottom && !_isFetching) {
      _isFetching = true;
      context.read<HomeBloc>().add(FetchDataEvent());
      Future.delayed(const Duration(seconds: 1), () => _isFetching = false);
    }
    if (_isBottom) {
      context.read<HomeBloc>().add(FetchDataEvent());
    }
  }

  bool get _isBottom {
    if (context.read<HomeBloc>().state.hasMore) {
      return false;
    }
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll);
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

  void _onSearchTask(String keySearch) async {
    context.read<HomeBloc>().add(SearchTaskEvent(keySearch));
    setState(() {
      _textController.text = keySearch;
    });
  }

  void _resetWhenSearchOf() async {
    _textController.clear();
    _showSearch = false;
    context.read<HomeBloc>().add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomSearchAppbar(
          showSearch: _showSearch,
          onToggleSearch: (value) => setState(() {
            _showSearch = value;
            _resetWhenSearchOf();
          }),
          onSearch: _onSearchTask,
          searchController: _textController,
          appbar: _buildAppBar(context),
        ),
        drawer: _openDrawer(context),
        body: Column(
          children: [
            _showSearch ? const SizedBox() : _buildTabView(context),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              child: _buildTaskGrid(context),
            ),
          ],
        ),
        floatingActionButton: _floatingActionButton(context),
      ),
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
            icon: Icon(
              Icons.menu,
              size: 24.sp,
            ),
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
          icon: Icon(
            Icons.search,
            size: 25.sp,
          ),
        ),
        IconButton(
          onPressed: () {
            NavigatorService.pushNamed(AppRoutes.contactScreen);
          },
          icon: Icon(
            Icons.person_add_alt_1_outlined,
            size: 25.sp,
          ),
        ),
        IconButton(
          onPressed: () {
            NavigatorService.pushNamed(AppRoutes.notificationScreen);
          },
          icon: Icon(
            Icons.notifications_none,
            size: 25.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildTabView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildOptionTask(context),
        CustomIconButton(
          onTap: () {
            onTapOpenFilterTask(context);
          },
          child: Icon(
            Icons.filter_list_sharp,
            size: 30.sp,
          ),
        )
      ],
    );
  }

  Widget _buildOptionTask(BuildContext context) {
    List<String> trans = Utils().typeTasks.map((time) => time.tr()).toList();
    int index;
    return BlocSelector<HomeBloc, HomeState, HomeInitialModel?>(
      selector: (state) => state.homeInitialModel,
      builder: (context, state) {
        return CustomDropdownButton(
          width: 200.w,
          textStyle: Theme.of(context).textTheme.bodyMedium,
          items: trans,
          value: PrefUtils().getTypeTask().tr(),
          onChanged: (value) {
            index = trans.indexOf(value!);
            String? indexValue = Utils().typeTasks[index];
            context.read<HomeBloc>().add(ChangeTypeEvent(type: indexValue));
          },
        );
      },
    );
  }

  Widget _buildTaskGrid(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, HomeState>(
      selector: (state) => state,
      builder: (context, state) {
        String timeNow = "TODAY".tr();
        bool has = false;
        List<Widget> customDisplay = [];
        List<TaskData> listTaskData = [];
        if (_showSearch) {
          listTaskData = state.resultSearch;
        } else {
          listTaskData = state.homeInitialModel.listTasks;
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
      },
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
              Text(userData.mention!,
                  style: Theme.of(context).textTheme.titleSmall),
              Text(userData.email!,
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
              PrefUtils().clearPreferentcesData();
              await TokenStorage.deleteToken();
              await TokenStorage.deleteRefresh();
              NavigatorService.pushNamedAndRemoveUtil(AppRoutes.loginScreen);
            },
          ),
        ],
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        onTapCreateNewTask(context);
      },
      child: Icon(
        Icons.add,
        size: 25.w,
      ),
    );
  }

  onTapCreateNewTask(BuildContext context) {
    showDialog(
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
  }

  onTapOpenFilterTask(BuildContext context) {
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
}

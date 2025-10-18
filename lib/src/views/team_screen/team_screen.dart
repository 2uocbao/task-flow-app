import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/team/team_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/progress_dialog_utils.dart';
import 'package:taskflow/src/views/create_team_dialog/create_team_dialog.dart';
import 'package:taskflow/src/views/home_screen/widgets/custom_search_appbar.dart';
import 'package:taskflow/src/views/team_screen/bloc/team_bloc.dart';
import 'package:taskflow/src/views/team_screen/bloc/team_event.dart';
import 'package:taskflow/src/views/team_screen/bloc/team_state.dart';
import 'package:taskflow/src/views/team_screen/widget/team_item_widget.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<TeamBloc>(
      create: (context) => TeamBloc(TeamState())..add(FetchTeamEvent()),
      child: const TeamScreen(),
    );
  }

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  String? updateTeamId;
  bool _onSearch = false;
  final TextEditingController _textController = TextEditingController();
  final logger = Logger();

  void startUpdate(String teamId) {
    setState(() {
      updateTeamId = teamId;
    });
  }

  void stopUpdate() {
    setState(() {
      updateTeamId = null;
    });
  }

  void search() {
    setState(() {
      _onSearch = !_onSearch;
    });
  }

  void _resetWhenSearchOf() async {
    _textController.clear();
    context.read<TeamBloc>().add(FetchTeamEvent());
  }

  void _onSearchTeam(String keySearch) async {
    if (keySearch.isNotEmpty) {
      context.read<TeamBloc>().add(SearchTeamEvent(keySearch: keySearch));

      setState(() {
        _textController.text = keySearch;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSearchAppbar(
        showSearch: _onSearch,
        onToggleSearch: (value) => setState(() {
          _onSearch = value;
          _resetWhenSearchOf();
        }),
        onSearch: _onSearchTeam,
        searchController: _textController,
        appbar: _buildAppBar(context),
      ),
      body: customBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 25.sp,
        ),
        onPressed: () {
          onTapCreateTeam(context);
        },
      ),
    );
  }

  Widget customBody(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, state) {
        if (state is FetchDataLoading) {
          ProgressDialogUtils.showProgressDialog();
        } else if (state is TeamErrorState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.error),
              SizedBox(height: 5.h),
              CustomTextButton(
                text: 'bt_reload'.tr(),
                onPressed: () {
                  context.read<TeamBloc>().add(FetchTeamEvent());
                },
              ),
            ],
          );
        } else if (state is TeamSuccessState) {
          NavigatorService.showSnackBar('lbl_update_success'.tr());
        }
        return _buildBody(context, state);
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leading: CustomIconButton(
        height: 30.h,
        width: 40.w,
        child: Icon(Icons.arrow_back_sharp, size: 25.sp),
        onTap: () {
          NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
        },
      ),
      actions: [
        CustomIconButton(
          height: 40.h,
          width: 40.w,
          child: Icon(Icons.search, size: 25.sp),
          onTap: () {
            search();
          },
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context, TeamState state) {
    if (state is FetchDataSuccess) {
      if (state.teamData.isEmpty && state.teamSearchResult.isEmpty) {
        return SizedBox(
          child: Center(
            child: Text('no_data_available'.tr()),
          ),
        );
      }
      if (_onSearch) {
        return _buildDisplayBody(context, state.teamSearchResult);
      }
      return _buildDisplayBody(context, state.teamData);
    } else {
      return const SizedBox();
    }
  }

  Widget _buildDisplayBody(BuildContext context, List<TeamData> teamDatas) {
    return ListView.builder(
      itemCount: teamDatas.length,
      itemBuilder: (context, index) {
        final model = teamDatas[index];
        return TeamItemWidget(
          teamData: model,
          addMember: (contact) {
            context
                .read<TeamBloc>()
                .add(AddMemberEvent(contactData: contact, teamData: model));
          },
          requestUpdate: (teamId, newName) {
            context
                .read<TeamBloc>()
                .add(UpdateTeamEvent(teamId: teamId, newName: newName));
          },
          isUpdate: updateTeamId == model.id,
          onUpdate: () => startUpdate(model.id!),
          onFinish: stopUpdate,
        );
      },
    );
  }

  Future<void> onTapCreateTeam(BuildContext context) async {
    final shouldReload = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: CreateTeamDialog.builder(
          NavigatorService.navigatorKey.currentContext!,
        ),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
      ),
    );
    if (shouldReload == true) {
      // ignore: use_build_context_synchronously
      context.read<TeamBloc>().add(FetchTeamEvent());
      NavigatorService.showSnackBar('lbl_create_team_success'.tr());
    }
  }
}

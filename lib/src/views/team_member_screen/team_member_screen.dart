import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/team/team_data.dart';
import 'package:taskflow/src/data/model/team_member/member_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/home_screen/widgets/custom_search_appbar.dart';
import 'package:taskflow/src/views/team_member_screen/model/team_member_argument.dart';
import 'package:taskflow/src/widgets/add_member_widget.dart';
import 'package:taskflow/src/views/team_member_screen/bloc/team_member_bloc.dart';
import 'package:taskflow/src/views/team_member_screen/bloc/team_member_event.dart';
import 'package:taskflow/src/views/team_member_screen/bloc/team_member_state.dart';

class TeamMemberScreen extends StatefulWidget {
  const TeamMemberScreen({super.key});

  static Widget builder(BuildContext context) {
    final arg =
        ModalRoute.of(context)?.settings.arguments as TeamMemberArgument;
    return BlocProvider<TeamMemberBloc>(
      create: (context) => TeamMemberBloc(TeamMemberState())
        ..add(FetchTeamMemberEvent(teamId: arg.teamData.id!)),
      child: const TeamMemberScreen(),
    );
  }

  @override
  State<TeamMemberScreen> createState() => _TeamMemberScreenState();
}

class _TeamMemberScreenState extends State<TeamMemberScreen> {
  final GlobalKey<AddMemberWidgetState> addMemberKey = GlobalKey();
  final TextEditingController _textSearch = TextEditingController();
  late bool isAddMember = false;
  late bool isSearch = false;

  void _resetWhenSearchOff(String teamId) {
    setState(() {
      isSearch = false;
      _textSearch.clear();
      context.read<TeamMemberBloc>().add(SearchMemberOffEvent(teamId: teamId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)?.settings.arguments as TeamMemberArgument;
    return Scaffold(
      appBar: _buildSearchAppBar(context, arg.teamData),
      body: _buildBody(context, arg.teamData),
    );
  }

  void _onSearchTeam(String teamId, String keySearch) async {
    if (keySearch.isNotEmpty) {
      context
          .read<TeamMemberBloc>()
          .add(SearchMemberEvent(teamId: teamId, keyword: keySearch));
      setState(() {
        _textSearch.text = keySearch;
      });
    }
  }

  PreferredSizeWidget _buildSearchAppBar(
      BuildContext context, TeamData teamData) {
    return CustomSearchAppbar(
      showSearch: isSearch,
      onToggleSearch: (value) => setState(() {
        isSearch = false;
        _resetWhenSearchOff(teamData.id!);
      }),
      searchController: _textSearch,
      appbar: _buildAppBar(context, teamData.creatorId!),
      onSearch: (keyword) {
        _onSearchTeam(teamData.id!, keyword);
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String creatorId) {
    return CustomAppBar(
      height: 30.h,
      leading: CustomIconButton(
        child: Icon(
          Icons.arrow_back_outlined,
          size: 25.sp,
        ),
        onTap: () {
          NavigatorService.goBack();
        },
      ),
      actions: [
        CustomIconButton(
          height: 30.sp,
          width: 30.sp,
          margin: EdgeInsets.only(right: 5.w),
          child: Icon(
            Icons.search,
            size: 25.sp,
          ),
          onTap: () {
            context.read<TeamMemberBloc>().add(TeamMemberInitialEvent());
            setState(() {
              isSearch = true;
            });
          },
        ),
        if (creatorId == PrefUtils().getUser()!.id) ...{
          CustomIconButton(
            height: 30.sp,
            width: 30.sp,
            margin: EdgeInsets.only(right: 5.w),
            child: Icon(
              !isAddMember ? Icons.person_add : Icons.check,
              size: 25.sp,
            ),
            onTap: () {
              setState(() {
                isAddMember = !isAddMember;
              });
            },
          ),
        }
      ],
    );
  }

  Widget _buildBody(BuildContext context, TeamData teamData) {
    return BlocBuilder<TeamMemberBloc, TeamMemberState>(
      builder: (context, state) {
        if (state is TeamMemberErrorState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.error),
              SizedBox(height: 5.h),
              CustomTextButton(
                text: 'bt_reload'.tr(),
                onPressed: () {
                  context
                      .read<TeamMemberBloc>()
                      .add(FetchTeamMemberEvent(teamId: teamData.id!));
                },
              ),
            ],
          );
        } else if (state is TeamMemberSuccess) {
          return SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              children: [
                if (isAddMember) ...{
                  AddMemberWidget(
                    key: addMemberKey,
                    teamId: teamData.id!,
                    height: 300.h,
                    addMember: (contact) {
                      context.read<TeamMemberBloc>().add(AddMemberEvent(
                          concactId: contact.userId!, teamData: teamData));
                    },
                  )
                } else ...{
                  if (state.memberDatas.isEmpty) ...{
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      'no_data_available'.tr(),
                    ),
                  } else ...{
                    Expanded(
                        child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: state.memberDatas.length,
                      itemBuilder: (context, index) {
                        return _buildDisplayMember(
                            context,
                            state.memberDatas[index],
                            teamData.creatorId!,
                            teamData);
                      },
                    ))
                  }
                }
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildDisplayMember(BuildContext context, MemberData memberData,
      String creatorIdTeam, TeamData teamData) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadiusStyle.circleBorder10),
        padding:
            EdgeInsets.only(left: 10.w, top: 10.h, right: 10.w, bottom: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCircleAvatar(imagePath: memberData.memberImage!, size: 30.sp),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memberData.memberName!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  memberData.joinedAt!,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            ),
            const Spacer(),
            if (creatorIdTeam == PrefUtils().getUser()!.id) ...{
              CustomIconButton(
                height: 30.h,
                width: 30.w,
                child: Icon(
                  Icons.remove_circle_outline,
                  size: 30.sp,
                ),
                onTap: () {
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => AlertDialog(
                  //     content: ConfirmDeleteDialog.builder(
                  //         NavigatorService.navigatorKey.currentContext!,
                  //         CustomId(
                  //           teamId: teamData.id,
                  //           memberId: memberData.id,
                  //           type: 'MEMBER',
                  //           title: 'lbl_title_delete_member'.tr(),
                  //           subTitle: 'lbl_subtitle_delete_member'.tr(),
                  //         )),
                  //     backgroundColor: Colors.transparent,
                  //     contentPadding: EdgeInsets.zero,
                  //     insetPadding: EdgeInsets.zero,
                  //   ),
                  // );
                  context.read<TeamMemberBloc>().add(RemoveMemberEvent(
                      teamData: teamData, teamMemberId: memberData.id!));
                },
              )
            }
          ],
        ),
      ),
    );
  }
}

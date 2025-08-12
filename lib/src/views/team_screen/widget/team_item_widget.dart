import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/team/team_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';
import 'package:taskflow/src/views/team_member_screen/model/team_member_argument.dart';
import 'package:taskflow/src/views/team_screen/bloc/team_bloc.dart';
import 'package:taskflow/src/views/team_screen/bloc/team_event.dart';
import 'package:taskflow/src/views/team_screen/bloc/team_state.dart';
import 'package:taskflow/src/widgets/add_member_widget.dart';

class TeamItemWidget extends StatelessWidget {
  final TeamData teamData;

  final Function(ContactData) addMember;

  final Function(String teamId, String newName) requestUpdate;

  final bool isUpdate;

  final VoidCallback onUpdate;

  final VoidCallback onFinish;

  // ignore: prefer_const_constructors_in_immutables
  TeamItemWidget({
    super.key,
    required this.teamData,
    required this.addMember,
    required this.requestUpdate,
    required this.isUpdate,
    required this.onUpdate,
    required this.onFinish,
  });

  late final String originalName;

  late final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    originalName = teamData.name!;
    _nameController = TextEditingController(text: originalName);
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (isUpdate) {
              onFinish();
            } else {
              NavigatorService.pushNamed(AppRoutes.teamMemberScreen,
                  arguments: TeamMemberArgument(teamData: teamData));
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadiusStyle.circleBorder10),
            padding:
                EdgeInsets.only(left: 5.w, top: 5.h, right: 5.w, bottom: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    isUpdate
                        ? Expanded(
                            child: CustomTextFormField(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2.w, horizontal: 2.h),
                            controller: _nameController,
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                          ))
                        : Text(teamData.name!,
                            style: Theme.of(context).textTheme.bodyLarge),
                    const Spacer(),
                    if (teamData.creatorId == PrefUtils().getUser()!.id) ...{
                      !isUpdate
                          ? CustomIconButton(
                              width: 30.w,
                              height: 25.h,
                              onTap: onUpdate,
                              child: Icon(
                                Icons.mode_edit_outline_outlined,
                                size: 20.sp,
                              ),
                            )
                          : Row(children: [
                              CustomIconButton(
                                width: 30.w,
                                height: 25.h,
                                child: Icon(
                                  Icons.check,
                                  size: 20.sp,
                                ),
                                onTap: () {
                                  onFinish();
                                  requestUpdate(
                                      teamData.id!, _nameController.text);
                                },
                              ),
                              CustomIconButton(
                                width: 30.w,
                                height: 25.h,
                                child: Icon(
                                  Icons.close,
                                  size: 20.sp,
                                ),
                                onTap: () {
                                  onFinish();
                                },
                              )
                            ]),
                      Builder(
                        builder: (context) {
                          return Transform.rotate(
                            angle: 90 * 3.1415926535 / 180,
                            child: CustomIconButton(
                              width: 30.w,
                              height: 25.h,
                              child: Icon(Icons.keyboard_control_sharp,
                                  size: 20.sp),
                              onTap: () {
                                showOptionTeam(context);
                              },
                            ),
                          );
                        },
                      ),
                    } else ...{
                      CustomIconButton(
                        width: 30.w,
                        height: 25.h,
                        child: Icon(
                          Icons.logout,
                          size: 20.sp,
                        ),
                        onTap: () {
                          context
                              .read<TeamBloc>()
                              .add(LeaveTeamEvent(teamData: teamData));
                        },
                      )
                    }
                  ],
                ),
                SizedBox(height: 10.h),
                Text('lbl_leader'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium),
                Row(
                  children: [
                    CustomCircleAvatar(
                        imagePath: teamData.creatorImage!, size: 25.sp),
                    SizedBox(width: 10.w),
                    Text(teamData.creatorName!,
                        style: Theme.of(context).textTheme.bodyMedium)
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                  '${'lbl_joinAt'.tr()} ${teamData.createdAt!}',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future showOptionTeam(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    return showMenu(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusStyle.circleBorder10,
        side: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary, width: 2.w),
      ),
      items: [
        PopupMenuItem(
          child: Text(
            "bt_add_member".tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () {
            onTapAddMember(context);
          },
        ),
        PopupMenuItem(
          child: Text(
            "bt_delete".tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: ConfirmDeleteDialog.builder(
                  context,
                  CustomId(
                    teamId: teamData.id,
                    type: 'TEAM',
                    title: 'lbl_title_delete_team'.tr(),
                    subTitle: 'lbl_subtitle_delete_team'.tr(),
                  ),
                ),
                backgroundColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                insetPadding: EdgeInsets.zero,
              ),
            );
          },
        ),
      ],
    );
  }

  void onTapAddMember(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusStyle.circleBorder10,
            color: Theme.of(context).colorScheme.surface,
          ),
          padding:
              EdgeInsets.only(left: 10.w, right: 10.h, top: 10.h, bottom: 10.h),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'bt_add_member'.tr(),
              ),
              SizedBox(
                height: 5.h,
              ),
              AddMemberWidget(
                  teamId: teamData.id!, addMember: addMember, height: 150.h),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
      ),
    );
  }
}

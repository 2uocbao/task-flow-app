import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/task/assign_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_bloc.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_event.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_state.dart';

class DetailAssignDialog extends StatefulWidget {
  const DetailAssignDialog({super.key});

  @override
  State<DetailAssignDialog> createState() => _DetailAssignDialogState();
}

class _DetailAssignDialogState extends State<DetailAssignDialog> {
  bool? isRemove = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: BlocBuilder<TaskDetailBloc, TaskDetailState>(
        builder: (context, state) {
          if (state is FetchTaskSuccess) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusStyle.circleBorder5,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'lbl_assignee'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 10.h),
                      _buildAssignDetail(context, state.listAssigns),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomTextButton(
                            text: 'bt_done'.tr(),
                            onPressed: () async {
                              NavigatorService.goBack();
                            },
                          ),
                          SizedBox(width: 10.w),
                        ],
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildAssignDetail(
      BuildContext context, List<AssignData> assignDatas) {
    String currentId = PrefUtils().getUser()!.id!;
    String adminUser = assignDatas
        .firstWhere((element) => element.role == 'ADMIN')
        .assignerId!;
    bool isAdminUser = adminUser == currentId;
    return SizedBox(
      height:
          assignDatas.length * 40.h > 150.h ? 150.h : assignDatas.length * 40.h,
      width: double.maxFinite,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: assignDatas.length,
        itemBuilder: (context, index) {
          if (assignDatas[index].assignerId == adminUser) {
            return const SizedBox(
              height: 0,
            );
          }
          return SizedBox(
            height: 40.h,
            child: Row(
              children: [
                SizedBox(width: 10.w),
                CustomCircleAvatar(
                  imagePath: assignDatas[index].image!,
                  size: 40,
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentId == assignDatas[index].assignerId
                          ? 'lbl_you'.tr()
                          : assignDatas[index].name!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      assignDatas[index].joinedAt!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                if (isAdminUser) ...{
                  CustomIconButton(
                    height: 30.h,
                    width: 35.w,
                    onTap: () {
                      context.read<TaskDetailBloc>().add(
                          RemoveAssignEvent(assignId: assignDatas[index].id!));
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 30.sp,
                    ),
                  ),
                },
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

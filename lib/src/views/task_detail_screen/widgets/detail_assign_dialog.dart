import 'package:easy_localization/easy_localization.dart';
<<<<<<< HEAD
import 'package:taskflow/src/data/model/task/assign_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_bloc.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_event.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_state.dart';

class DetailAssignDialog extends StatefulWidget {
  const DetailAssignDialog({super.key});

=======
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/widgets/custom_text_button.dart';

class DetailAssignDialog extends StatefulWidget {
  const DetailAssignDialog(
      {super.key,
      required this.removeAssign,
      required this.usernameAssigner,
      required this.imageAssigner});

  final VoidCallback removeAssign;
  final String usernameAssigner;
  final String imageAssigner;
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  @override
  State<DetailAssignDialog> createState() => _DetailAssignDialogState();
}

class _DetailAssignDialogState extends State<DetailAssignDialog> {
  bool? isRemove = true;
<<<<<<< HEAD
=======

>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
    return SizedBox(
      height:
          assignDatas.length * 40.h > 150.h ? 150.h : assignDatas.length * 40.h,
      width: double.maxFinite,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: assignDatas.length,
        itemBuilder: (context, index) {
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
                  children: [
                    Text(
                      assignDatas[index].name!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      assignDatas[index].joinedAt!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
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
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
          );
        },
      ),
=======
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadiusStyle.circleBorder5,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  'lbl_assignee'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRemove = !isRemove!;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      ClipOval(
                        child: CustomImageView(
                          height: 40.sp,
                          width: 40.sp,
                          imagePath: widget.imageAssigner,
                          fit: BoxFit.cover,
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        widget.usernameAssigner,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      isRemove!
                          ? Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTextButton(
                    text: 'DONE',
                    onPressed: () async {
                      if (!isRemove!) {
                        widget.removeAssign();
                      }
                      NavigatorService.goBack();
                    },
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        )
      ],
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    );
  }
}

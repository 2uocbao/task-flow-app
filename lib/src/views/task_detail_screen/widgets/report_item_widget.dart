import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/report/report_data.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_bloc.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_event.dart';

<<<<<<< HEAD
class ReportItemWidget extends StatelessWidget {
  final ReportData reportData;
  final TaskData taskData;
=======
// ignore: must_be_immutable
class ReportItemWidget extends StatelessWidget {
  ReportData reportData;
  TaskData taskData;

  // final Function(String fileName) requestFocus;
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

  ReportItemWidget(
    this.reportData,
    this.taskData, {
    super.key,
  });

  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
<<<<<<< HEAD
          SizedBox(width: 10.w),
=======
          SizedBox(
            width: 10.w,
          ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: GestureDetector(
                    child: Text(
                      reportData.filename ?? reportData.externalUrl!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      if (reportData.type == 'FILE') {
                        logger.i('message');
                        context
                            .read<TaskDetailBloc>()
                            .add(OpenFileEvent(reportData));
                      } else {
                        context
                            .read<TaskDetailBloc>()
                            .add(OpenUrlEvent(reportData.externalUrl!));
                      }
                    },
                  ),
                ),
                SizedBox(
                  child: Text(
                    reportData.createdAt!,
<<<<<<< HEAD
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: 10.sp),
=======
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: 10.sp,
                        ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                  ),
                )
              ],
            ),
          ),
          Transform.rotate(
            angle: 90 * 3.1415926535 / 180,
            child: CustomIconButton(
              onTap: () {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final Offset buttonPosition =
                    button.localToGlobal(Offset.zero, ancestor: overlay);
                final Size buttonSize = button.size;
                final Size overlaySize = overlay.size;

                final RelativeRect position = RelativeRect.fromLTRB(
                  buttonPosition.dx + buttonSize.width,
                  buttonPosition.dy + 30.h,
                  overlaySize.width - (buttonPosition.dx + buttonSize.width),
                  overlaySize.height - (buttonPosition.dy + buttonSize.height),
                );
                showMenu(
                  context: context,
                  position: position,
                  items: [
                    // PopupMenuItem(
                    //   child: Text(
                    //     "bt_reply".tr(),
                    //     style: Theme.of(context).textTheme.bodySmall,
                    //   ),
                    //   onTap: () {
                    //     requestFocus(reportData.filename!);
                    //   },
                    // ),
                    PopupMenuItem(
                      child: Text(
                        "bt_download".tr(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () {
                        context.read<TaskDetailBloc>().add(DownloadFileEvent(
                            fileName: reportData.filename!,
                            reportId: reportData.id!));
                      },
                    ),
                    PopupMenuItem(
<<<<<<< HEAD
                      child: Text("bt_delete".tr(),
                          style: Theme.of(context).textTheme.bodySmall),
=======
                      child: Text(
                        "bt_delete".tr(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: ConfirmDeleteDialog.builder(
                              context,
                              CustomId(
                                reportId: reportData.id,
                                taskId: taskData.id,
<<<<<<< HEAD
                                type: 'REPORT',
                                title: 'lbl_title_delete_file'.tr(),
                                subTitle: 'lbl_subtitle_delete_file'.tr(),
=======
                                type: 'Report',
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
              },
<<<<<<< HEAD
              child: Icon(Icons.keyboard_control_sharp, size: 25.sp),
=======
              child: Icon(
                Icons.keyboard_control_sharp,
                size: 25.sp,
              ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
            ),
          ),
        ],
      ),
    );
  }
}

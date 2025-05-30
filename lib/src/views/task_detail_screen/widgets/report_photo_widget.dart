import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/model/report/report_data.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_bloc.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_event.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/image_page_screen.dart';

// ignore: must_be_immutable
class ReportPhotoWidget extends StatelessWidget {
  List<ReportData> reportDatas;
  TaskData taskData;
  // final Function(String filename) requestFocus;
  ReportPhotoWidget(
    this.reportDatas,
    this.taskData, {
    super.key,
  });
  final GlobalKey iconKey = GlobalKey();
  final Map<String, GlobalKey> globalKey = {};

  @override
  Widget build(BuildContext context) {
    for (var reportData in reportDatas) {
      globalKey[reportData.id!] = GlobalKey();
    }
    return SizedBox(
      height: 150.h,
      width: double.maxFinite,
      child: ListView.builder(
        itemCount: reportDatas.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              CustomImageView(
                margin: EdgeInsets.only(left: 5.w),
                height: 150.h,
                width: 150.w,
                fit: BoxFit.cover,
                imagePath:
                    "${Api().url}/users/${PrefUtils().getUser()!.id}/tasks/${taskData.id}/reports/${reportDatas[index].id}/view",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImagePageScreen(
                          imageUrl:
                              "${Api().url}/users/${PrefUtils().getUser()!.id}/tasks/${taskData.id}/reports/${reportDatas[index].id}/view"),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 5.h,
                right: 5.w,
                child: Transform.rotate(
                  angle: 90 * 3.1415926535 / 180,
                  child: CustomIconButton(
                    key: globalKey[reportDatas[index].id],
                    child: Icon(
                      Icons.keyboard_control_sharp,
                      size: 25.sp,
                      color: Colors.white,
                    ),
                    onTap: () {
                      final RenderBox button = globalKey[reportDatas[index].id]
                          ?.currentContext!
                          .findRenderObject() as RenderBox;
                      final RenderBox overlay = Overlay.of(context)
                          .context
                          .findRenderObject() as RenderBox;
                      final RelativeRect position = RelativeRect.fromRect(
                        Rect.fromPoints(
                          button.localToGlobal(Offset.zero, ancestor: overlay),
                          button.localToGlobal(
                              button.size.bottomRight(Offset.zero),
                              ancestor: overlay),
                        ),
                        Offset.zero & overlay.size,
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
                          //     requestFocus(reportDatas[index].filename!);
                          //   },
                          // ),
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
                                      reportId: reportDatas[index].id,
                                      taskId: taskData.id,
                                      type: 'Report',
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  contentPadding: EdgeInsets.zero,
                                  insetPadding: EdgeInsets.zero,
                                ),
                              );
                            },
                          ),
                          PopupMenuItem(
                            child: Text(
                              "bt_download".tr(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            onTap: () {
                              context.read<TaskDetailBloc>().add(
                                  DownloadFileEvent(
                                      fileName: reportDatas[index].filename!,
                                      reportId: reportDatas[index].id!));
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
